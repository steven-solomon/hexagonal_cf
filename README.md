# Deploying a Hexagonal Application to Cloud Foundry 

You are probably about to write a new rails application. STOP! Before you run `rails new <Your app name>`. I want 
to talk to you about Dependency Inversion. What's that you ask?

Dependency Inversion is the idea that your code should depend on abstractions and not concretions. (1)
You might be staring blankly at the web page right now. Said another way, your code should depend not on a specific
object, model or function but the contract that your code requires. If I had a Cart object, it should not know about 
the Html used to render it but rather the abstraction of a CartPresenter interface. The CartPresenter might render HTML,
 it might render JSON, or some future format. Who cares. The point is the Cart shouldn't have to know those details.
 
So what does any of that have to do with Rails you ask? Well just like Cart doesn't know about HTML, your application
shouldn't know it is a Rails App. This will allow your application logic ( the stuff you actually care about ) to live longer
than any version of Rails or maybe even the Rails framework itself. 
 
Let's take a look at this idea in practice. I want to walk you through setting up such an application and then 
deploying it to Cloud Foundry. First let's start with the directory structure for an example application that sells sheetmusic AwesomeScores.com. 
At the top level we want our application to scream AwesomeScores.com, that is because that is the important part. (2)
So let's create a gem that will contain our core business logic. 

```
$ bundle gem awesome_scores --no-exe --no-coc --test=rspec --no-mit
```

I have excluded code of conduct, an exe, mit license and opted to use Rspec. If your 
preferences differ feel free to tweak the command. Make sure to remove/update the generated gemspec to 
include at least summary and authors.

Now that we have our gem lets talk about where rails should go. Well since Rails is a detail as Uncle Bob would say, we should
put it as a plugin to our app. Let's create a plugin directory. 

```
$ mkdir plugins
```

Now lets make our Rails app. Navigate to the plugins directory and run the rails new command.
We skip the tests since we will be using rspec.
```
$ cd plugins
$ rails new web --skip-test
```

It will get pretty annoying changing directory levels just to execute `rails s` so lets add a quick toplevel task `rake s`
 to start the server. 
 
```
# Rakefile in root directory
task :s do
  chdir 'plugins/web' do
    system 'rails s'
  end
end
```

From the root directory we can now start the server.

```
$ cd .. # navigate to root
$ rake s
```

Now our server is running! But the pieces aren't together yet. Let's build our first story. "Wait!" you might be thinking.
"We haven't even setup everything and we are going to be working on a feature?!". Yes. Our goal as engineers should be 
to deliver business value. Our Product Manager has worked to define thinly sliced pieces of user value and we want to 
deliver on that while also building out our architecture just enough for everything to work. This is part of thinking in Extreme Programming (3)

So here is our first user story. 
~~~~
Given I am an Anonymous User
When I add a free score to the cart
And checkout
Then I can view the score 
~~~~

We had a short discussion with our Designer and PM and we came to the agreement that this first story won't have a confirmation
page since the only product we will have is free. Instead the user can immediately access the score and won't be asked for credit card information.

As in the XP style we begin with a failing feature test, then we will unit test any logic, and finally deploy the app to cloud foundry so that 
the PM can confirm that the feature is complete. 

Let's install Capybara and Rspec so we can do feature testing. 
Edit the Gemfile of the rails app to include rspec-rails and capybara.
```
group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'capybara'
end
```

Next run bundle from within the rails app directory.
```
$ bundle install
$ rails g rspec:install
```

That's going to get annoying as well so lets modify our toplevel rake task
```
# Rakefile in root directory
task :s do
  chdir 'plugins/web' do
    system 'bundle'
    system 'rails s'
  end
end
```

Now let's write our first feature test. Inside the web application create the following test.

```ruby
require 'rails_helper'

feature 'anonymous user' do
  before do
    Score.create(price: 0, title: 'Free Score')
  end

  scenario 'can buy a free score' do
    given_I_am_on_the_homepage
    when_I_add_the_free_score_to_my_cart
    and_I_checkout
    then_I_see_the_score
  end

  def given_I_am_on_the_homepage
    visit '/'
  end

  def when_I_add_the_free_score_to_my_cart
    click_on 'Free Score'

    expect(find('[data-title]')).to have_content('Free Score')
    expect(find('[data-price]')).to have_content('Free')
    expect(page).not_to have_css('.score-container')

    click_on 'Add to Cart'

    expect(find('[data-items-count]')).to have_content('1')
    expect(find('[data-score-title]')).to have_content('Free Score')
    expect(find('[data-score-price]')).to have_content('Free')
    expect(find('[data-total]')).to have_content('Free')
  end

  def and_I_checkout
    click_on 'Checkout'

    expect(find('#complete')).to be_truthy
  end

  def then_I_see_the_score
    first('.score').click

    expect(page).to have_content('Free Score')
    expect(find('.score-container')).to be_truthy
  end
end
```

In order to run our tests in a convenient way, lets create a toplevel task to run all tests in the system. It is also important
to make sure that a failing test run bubbles up the failure as a non-zero exit status code. So we check for that
using the `$?` variable which contains the last run process.

```ruby
# Rootlevel rakefile

task :default do
  chdir 'plugins/web' do
    system 'bundle'
    system 'rake db:migrate'
    system 'rake db:test:prepare'
  end

  raise 'tests failed' if any_failures(%w(plugins/web awesome_scores))
end

def any_failures(targets)
  targets
      .map {|path| run_tests(path)}
      .any? {|status_code| status_code != 0}
end

def run_tests(path)
  exitstatus = nil
  chdir path do
    system 'rake'
    exitstatus = $?.exitstatus
  end
  exitstatus
end
```
 
Now we can run the test from the top level. 
```bash
$ rake 
```

Our test now fails. I am going to omit the TDD workflow that I would do here and just give you the code to pass the 
tests and specify where it lives. But there are number of fast cycles of Red - Green - Refactor that are taken to arrive at this
code. It is by no means the code that made the initial tests pass and has change as the consequence of each new test.

There have already been a few great voices on how to build out functionality using the Hexagonal Architecture.
I don't want to rehash those ideas here. Checkout the original post by Cockburn 4, Matt Parker Screen cast on Hexagonal in Rails 5, 
and Jim Weirich Decoupling from rails 6.

You can see the code that passes the above tests here: https://github.com/steven-solomon/hexagonal_cf

Now that we have such an app we want to be able to push it to Cloud Foundry where our PM can accept our story. 
However before we do that we need to setup a manifest. 
This manifest will have a path for our rails app and the typical app config. Also note
the random-route flag so you don't collide when you run this tutorial 

```yaml
---
applications:
- name: hexagonal_cf
  memory: 512M
  host: hexagonal_cf
  path: ./plugins/web
  random-route: true 
```

Next in order to actually push we need to make sure our local gem is pushed up to Cloud Foundry 
in order to do this we need to execute `bundle package -all` in the rails app directory. But we don't
want to do this by hand each time as it will be easy to forget so let's right a push task 

```ruby
namespace :acceptance do
  task :push do
    chdir 'plugins/web' do
      system 'bundle package --all'
    end
    system 'cf push'
  end
end
```

In order to push our app we won't want to add the bloat of all the packaged gems
we only want to send ours. So create a `.cfignore` file for the rails app and add the rails 
default `.gitnore` contents then add the following at the end.

```plugins/web/.cfignore
# rails ignore above...
spec
!vendor/cache/awesome_scores/*
```

Now that we are setup we can push using our rake task. However the first time will fail as 
we don't have a database setup. Let's add that...
 
1. [Martin pg 127 PPP]
2. [Martin https://www.youtube.com/watch?v=Nsjsiz2A9mg]
3. [Beck XP 99]
4. [Cockburn http://alistair.cockburn.us/Hexagonal+architecture]
5. [Parker https://www.youtube.com/channel/UCCptggI2qaxsBXiwfit6tNQ]
6. [Weirich https://www.youtube.com/watch?v=tg5RFeSfBM4]
