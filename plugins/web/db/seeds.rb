# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

score = Score.create(title: "Say It Ain't So", price: 0)
PurchasedContent.create(score_id: score.id, content: <<-SONG)
Oh yeah
Alright

Somebody's Heine'
Is crowdin' my icebox
Somebody's cold one
Is givin' me chills
Guess I'll just close my eyes

Oh yeah
Alright
Feels good
Inside

Flip on the tele
Wrestle with Jimmy
Something is bubbling
Behind my back
The bottle is ready to blow

Say it ain't so
Your drug is a heart-breaker
Say it ain't so
My love is a life-taker

I can't confront you
I never could do
That which might hurt you
So try and be cool
When I say
This way is a water-slide away from me
That takes you further every day
So be cool

Say it ain't so
Your drug is a heart-breaker
Say it ain't so
My love is a life-taker

Dear Daddy
I write you in spite of years of silence
You've cleaned up, found Jesus, things are good or so I hear
This bottle of Steven's awakens ancient feelings
Like father, stepfather, the son is drowning in the flood
Yeah, yeah-yeah, yeah-yeah

Say it ain't so
Your drug is a heart-breaker
Say it ain't so
My love is a life-taker
SONG