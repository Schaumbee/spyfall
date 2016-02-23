use Mix.Config

config :spyfall,
instructions: ~s(
Spyfall is a text adventure unlike any other, one in which you get to be a spy and try to understand what's going on around you. It's really simple!

Spyfall is played over several rounds, and at the start of each round all players receive the same location and a role that is specific to tht location — except that one player is told that he is the "Spy" instead of receiving a lotcation. Players then start asking each other questions — "Why are you dressed so strangely?" or "When was the last time we got a payday?" or anything else you can come up with — trying to guess who among them is the spy. The spy doesn't know where he is, so he has to listen carefully. When it's his time to answer, he'd better create a good story!

At any time during a round, one player may accuse another of being a spy. It is a good idea to discuss your guess with others before officially submitting your guess. If the spy is uncovered, all other players win. However, the spy can himself end a round by announcing that he understands what the secret location is; if his guess is correct, only the spy wins.
),

commands: ~s(
To interact with the game, simply use one of the following commands. James Bond will answer your request and act accordingly.

*Lobby*
When there is no game current in play, you can use the following commands.

`join` enter yourself in the next round of the game
`leave` leave the next round of the game if you no longer wish to play
`lobby` list the current players that are waiting to play the next round
`start` starts the game with the current players in the lobby

*Playing the game*
Once in the game, you will ask other players questions. To record your guess, use the following commands.

`location: [location]` if you are the spy, this acts as your guess and ends the game
`spy: [spy]` if you are not the spy, this acts as your guess and ends the game

*Help*
You can issue these commands at any time. Running these commands will send a direct message to you with the information.

`instructions` displays the game instructions and objectives
`commands` displays the commands that can be used in the game
`help` displays the instructions and the commands
),

locations: [
  {
    "Airplane",
    [
      "First Class Passenger",
      "Air Marshall",
      "Mechanic",
      "Air Hostess",
      "Copilot",
      "Captain",
      "Economy Class Passenger"
    ]
  },
  {
    "Bank",
    [
      "Armored Car Driver",
      "Manager",
      "Consultant",
      "Robber",
      "Security Guard",
      "Teller",
      "Customer"
    ]
  },
  {
    "Beach",
    [
      "Beach Waitress",
      "Kite Surfer",
      "Lifeguard",
      "Thief",
      "Beach Photographer",
      "Ice Cream Truck Driver",
      "Beach Goer"
    ]
  },
  {
    "Cathedral",
    [
      "Priest",
      "Beggar",
      "Sinner",
      "Tourist",
      "Sponsor",
      "Chorister",
      "Parishioner"
    ]
  },
  {
    "Circus Tent",
    [
      "Acrobat",
      "Animal Trainer",
      "Magician",
      "Fire Eater",
      "Clown",
      "Juggler",
      "Visitor"
    ]
  },
  {
    "Corporate Party",
    [
      "Entertainer",
      "Manager",
      "Unwanted Guest",
      "Owner",
      "Secretary",
      "Delivery Boy",
      "Accountant"
    ]
  },
  {
    "Crusader Army",
    [
      "Monk",
      "Imprisoned Saracen",
      "Servant",
      "Bishop",
      "Squire",
      "Archer",
      "Knight"
    ]
  },
  {
    "Casino",
    [
      "Bartender",
      "Head Security Guard",
      "Bouncer",
      "Manager",
      "Hustler",
      "Dealer",
      "Gambler"
    ]
  },
  {
    "Day Spa",
    [
      "Stylist",
      "Masseuse",
      "Manicurist",
      "Makeup Artist",
      "Dermatologist",
      "Beautician",
      "Customer"
    ]
  },
  {
    "Embassy",
    [
      "Security Guard",
      "Secretary",
      "Ambassador",
      "Tourist",
      "Refugee",
      "Diplomat",
      "Government Official"
    ]
  },
  {
    "Hospital",
    [
      "Nurse",
      "Doctor",
      "Anesthesiologist",
      "Intern",
      "Therapist",
      "Surgeon",
      "Patient"
    ]
  },
  {
    "Hotel",
    [
      "Doorman",
      "Security Guard",
      "Manager",
      "Housekeeper",
      "Bartender",
      "Bellman",
      "Customer"
    ]
  },
  {
    "Military Base",
    [
      "Deserter",
      "Colonel",
      "Medic",
      "Sniper",
      "Officer",
      "Tank Engineer",
      "Soldier"
    ]
  },
  {
    "Movie Studio",
    [
      "Stunt Man",
      "Sound Engineer",
      "Camera Man",
      "Director",
      "Costume Artist",
      "Producer",
      "Actor"
    ]
  },
  {
    "Ocean Liner",
    [
      "Cook",
      "Captain",
      "Bartender",
      "Musician",
      "Waiter",
      "Mechanic",
      "Rich Passenger"
    ]
  },
  {
    "Passenger Train",
    [
      "Mechanic",
      "Border Patrol",
      "Train Attendant",
      "Restaurant Chef",
      "Train Driver",
      "Stoker",
      "Passenger"
    ]
  },
  {
    "Pirate Ship",
    [
      "Cook",
      "Slave",
      "Cannoneer",
      "Tied Up Prisoner",
      "Cabin Boy",
      "Brave Captain",
      "Sailor"
    ]
  },
  {
    "Polar Station",
    [
      "Medic",
      "Expedition Leader",
      "Biologist",
      "Radioman",
      "Hydrologist",
      "Meteorologist",
      "Geologist"
    ]
  },
  {
    "Police Station",
    [
      "Detective",
      "Lawyer",
      "Journalist",
      "Criminalist",
      "Archivist",
      "Criminal",
      "Patrol Officer"
    ]
  },
  {
    "Restaurant",
    [
      "Musician",
      "Bouncer",
      "Hostess",
      "Head Chef",
      "Food Critic",
      "Waiter",
      "Customer"
    ]
  },
  {
    "School",
    [
      "Gym Teacher",
      "Principal",
      "Security Guard",
      "Janitor",
      "Cafeteria Lady",
      "Maintenance Man",
      "Student"
    ]
  },
  {
    "Service Station",
    [
      "Manager",
      "Tire Specialist",
      "Biker",
      "Car Owner",
      "Car Wash Operator",
      "Electrician",
      "Auto Mechanic"
    ]
  },
  {
    "Space Station",
    [
      "Engineer",
      "Alien",
      "Pilot",
      "Commander",
      "Scientist",
      "Doctor",
      "Space Tourist"
    ]
  },
  {
    "Submarine",
    [
      "Cook",
      "Commander",
      "Sonar Technician",
      "Electronics Technician",
      "Radioman",
      "Navigator",
      "Sailor"
    ]
  },
  {
    "Supermarket",
    [
      "Cashier",
      "Butcher",
      "Janitor",
      "Security Guard",
      "Food Sample Demonstrator",
      "Shelf Stocker",
      "Customer"
    ]
  },
  {
    "Theater",
    [
      "Coat Check Lady",
      "Prompter",
      "Cashier",
      "Director",
      "Actor",
      "Crew Man",
      "Audience Member"
    ]
  },
  {
    "University",
    [
      "Graduate Student",
      "Professor",
      "Dean",
      "Psychologist",
      "Maintenance Man",
      "Janitor",
      "Student"
    ]
  },
  {
    "World War II Squad",
    [
      "Resistance Fighter",
      "Radioman",
      "Scout",
      "Medic",
      "Cook",
      "Imprisoned Nazi",
      "Soldier"
    ]
  }
]
