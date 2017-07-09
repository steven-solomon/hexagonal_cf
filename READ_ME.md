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
preferences differ feel free to tweak the command.

Now that we have our gem lets talk about where rails should go. Well since Rails is a detail as Uncle Bob would say, we should
put it as a plugin to our app. Let's create a plugin directory. 

```
$ mkdir plugins
```

Now lets make our Rails app. Navigate to the plugins directory and run the rails new command.

```
$ cd plugins
$ rails new web
```

It will get pretty annoying flipping directory levels just to execute `rails s` so lets add a quick toplevel task `rake s`
 to start the server. 
 
```
# Rakefile in root directory
task :s do
  chdir 'plugins/web' do
    system 'rails s'
  end
end
```

From the root directory you can now start the server.

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

1. [Martin pg 127 PPP]
2. [Martin https://www.youtube.com/watch?v=Nsjsiz2A9mg]
3. [Beck XP 99]