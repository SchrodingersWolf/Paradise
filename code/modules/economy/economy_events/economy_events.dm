/datum/event/economic_event
	endWhen = 50			//this will be set randomly, later
	announceWhen = 15
	var/event_type = 0
	var/list/cheaper_goods = list()
	var/list/dearer_goods = list()
	var/datum/trade_destination/affected_dest

/datum/event/economic_event/start()
	affected_dest = pickweight(GLOB.weighted_randomevent_locations)
	if(length(affected_dest.viable_random_events))
		endWhen = rand(60,300)
		event_type = pick(affected_dest.viable_random_events)

		if(!event_type)
			return

		switch(event_type)
			if(RANDOM_STORY_RIOTS)
				dearer_goods = list(TRADE_GOOD_SECURITY)
				cheaper_goods = list(TRADE_GOOD_MINERALS, TRADE_GOOD_FOOD)
			if(RANDOM_STORY_WILD_ANIMAL_ATTACK)
				cheaper_goods = list(TRADE_GOOD_ANIMALS)
				dearer_goods = list(TRADE_GOOD_FOOD, TRADE_GOOD_BIOMEDICAL)
			if(RANDOM_STORY_INDUSTRIAL_ACCIDENT)
				dearer_goods = list(TRADE_GOOD_EMERGENCY, TRADE_GOOD_BIOMEDICAL, TRADE_GOOD_ROBOTICS)
			if(RANDOM_STORY_BIOHAZARD_OUTBREAK)
				dearer_goods = list(TRADE_GOOD_BIOMEDICAL, TRADE_GOOD_EGAS)
			if(RANDOM_STORY_PIRATES)
				dearer_goods = list(TRADE_GOOD_SECURITY, TRADE_GOOD_MINERALS)
			if(RANDOM_STORY_CORPORATE_ATTACK)
				dearer_goods = list(TRADE_GOOD_SECURITY, TRADE_GOOD_MAINTENANCE)
			if(RANDOM_STORY_ALIEN_RAIDERS)
				dearer_goods = list(TRADE_GOOD_BIOMEDICAL, TRADE_GOOD_ANIMALS)
				cheaper_goods = list(TRADE_GOOD_EGAS, TRADE_GOOD_MINERALS)
			if(RANDOM_STORY_AI_LIBERATION)
				dearer_goods = list(TRADE_GOOD_EMERGENCY, TRADE_GOOD_EGAS, TRADE_GOOD_MAINTENANCE)
			if(RANDOM_STORY_MOURNING)
				cheaper_goods = list(TRADE_GOOD_MINERALS, TRADE_GOOD_MAINTENANCE)
			if(RANDOM_STORY_CULT_CELL_REVEALED)
				dearer_goods = list(TRADE_GOOD_SECURITY, TRADE_GOOD_BIOMEDICAL, TRADE_GOOD_MAINTENANCE)
			if(RANDOM_STORY_SECURITY_BREACH)
				dearer_goods = list(TRADE_GOOD_SECURITY)
			if(RANDOM_STORY_ANIMAL_RIGHTS_RAID)
				dearer_goods = list(TRADE_GOOD_ANIMALS)
			if(RANDOM_STORY_FESTIVAL)
				dearer_goods = list(TRADE_GOOD_FOOD, TRADE_GOOD_ANIMALS)
		for(var/good_type in dearer_goods)
			affected_dest.temp_price_change[good_type] = rand(1,100)
		for(var/good_type in cheaper_goods)
			affected_dest.temp_price_change[good_type] = rand(1,100) / 100

/datum/event/economic_event/announce()
	//copy-pasted from the admin verbs to submit new newscaster messages
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = "Nyx Daily"
	newMsg.admin_locked = TRUE

	//see if our location has custom event info for this event
	newMsg.body = affected_dest.get_custom_eventstring()
	newMsg.title = affected_dest.get_custom_eventtitle() || "[newMsg.author]: "
	if(!newMsg.body)
		switch(event_type)
			if(RANDOM_STORY_RIOTS)
				newMsg.title += "Riots on [affected_dest.name]"
				newMsg.body = "[pick("Riots have","Unrest has")] broken out on planet [affected_dest.name]. Authorities call for calm, as [pick("various parties","rebellious elements","peacekeeping forces","\'REDACTED\'")] begin stockpiling weaponry and armour. Meanwhile, food and mineral prices are dropping as local industries attempt empty their stocks in expectation of looting."
			if(RANDOM_STORY_WILD_ANIMAL_ATTACK)
				newMsg.title += "Animal attack on [affected_dest.name]"
				newMsg.body = "Local [pick("wildlife","animal life","fauna")] on planet [affected_dest.name] has been increasing in aggression and raiding outlying settlements for food. Big game hunters have been called in to help alleviate the problem, but numerous injuries have already occurred."
			if(RANDOM_STORY_INDUSTRIAL_ACCIDENT)
				newMsg.title += "Industrial accident on [affected_dest.name]"
				newMsg.body = "[pick("An industrial accident","A smelting accident","A malfunction","A malfunctioning piece of machinery","Negligent maintenance","A coolant leak","A ruptured conduit")] at a [pick("factory","installation","power plant","dockyards")] on [affected_dest.name] resulted in severe structural damage and numerous injuries. Repairs are ongoing."
			if(RANDOM_STORY_BIOHAZARD_OUTBREAK)
				newMsg.title += "Viral outbreak on [affected_dest.name]"
				newMsg.body = "[pick("A \'REDACTED\'","A biohazard","An outbreak","A virus")] on [affected_dest.name] has resulted in quarantine, stopping much shipping in the area. Although the quarantine is now lifted, authorities are calling for deliveries of medical supplies to treat the infected, and gas to replace contaminated stocks."
			if(RANDOM_STORY_PIRATES)
				newMsg.title += "Attack on [affected_dest.name]"
				newMsg.body = "[pick("Pirates","Criminal elements","A [pick("Syndicate","Donk Co.","Waffle Co.","\'REDACTED\'")] strike force")] have [pick("raided","blockaded","attempted to blackmail","attacked")] [affected_dest.name] today. Security has been tightened, but many valuable minerals were taken."
			if(RANDOM_STORY_CORPORATE_ATTACK)
				newMsg.title += "Corporate attack on [affected_dest.name]"
				newMsg.body = "A small [pick("pirate","Cybersun Industries","Gorlex Marauders","Syndicate")] fleet has precise-jumped into proximity with [affected_dest.name], [pick("for a smash-and-grab operation","in a hit and run attack","in an overt display of hostilities")]. Much damage was done, and security has been tightened since the incident."
			if(RANDOM_STORY_ALIEN_RAIDERS)
				if(prob(20))
					newMsg.title += "Raid on [affected_dest.name]"
					newMsg.body = "The Tiger Co-operative have raided [affected_dest.name] today, no doubt on orders from their enigmatic masters. Stealing wildlife, farm animals, medical research materials and kidnapping civilians. Nanotrasen authorities are standing by to counter attempts at bio-terrorism."
				else
					newMsg.title += "Alien raid on [affected_dest.name]"
					newMsg.body = "[pick("The alien species designated \'United Exolitics\'","The alien species designated \'REDACTED\'","An unknown alien species")] have raided [affected_dest.name] today, stealing wildlife, farm animals, medical research materials and kidnapping civilians. It seems they desire to learn more about us, so the Navy will be standing by to accommodate them next time they try."
			if(RANDOM_STORY_AI_LIBERATION)
				newMsg.title += "Technoterrorist attack on [affected_dest.name]"
				newMsg.body = "A [pick("\'REDACTED\' was detected on","S.E.L.F operative infiltrated","malignant computer virus was detected on","rogue [pick("slicer","hacker")] was apprehended on")] [affected_dest.name] today, and managed to infect [pick("\'REDACTED\'","a sentient sub-system","a class one AI","a sentient defense installation")] before it could be stopped. Many lives were lost as it systematically begin murdering civilians, and considerable work must be done to repair the affected areas."
			if(RANDOM_STORY_MOURNING)
				var/job = pick("professor","entertainer","singer","researcher","public servant","administrator","ship captain","\'REDACTED\'")
				var/age = rand(27, 100)
				newMsg.title += "Famous [job] dies aged [age]"
				newMsg.body = "[pick("The popular","The well-liked","The eminent","The well-known")] [job], [pick( random_name(pick(MALE,FEMALE)), 40; "\'REDACTED\'" )] has [pick("passed away","committed suicide","been murdered","died in a freakish accident")] on [affected_dest.name] today. The entire planet is in mourning, and prices have dropped for industrial goods as worker morale drops."
			if(RANDOM_STORY_CULT_CELL_REVEALED)
				newMsg.title += "Cult cell revealed on [affected_dest.name]"
				newMsg.body = "A [pick("dastardly","blood-thirsty","villainous","crazed")] cult of [pick("The Elder Gods","Nar'sie","an apocalyptic sect","\'REDACTED\'")] has [pick("been discovered","been revealed","revealed themselves","gone public")] on [affected_dest.name] earlier today. Public morale has been shaken due to [pick("certain","several","one or two")] [pick("high-profile","well known","popular")] individuals [pick("performing \'REDACTED\' acts","claiming allegiance to the cult","swearing loyalty to the cult leader","promising to aid to the cult")] before those involved could be brought to justice. The editor reminds all personnel that supernatural myths will not be tolerated on Nanotrasen facilities."
			if(RANDOM_STORY_SECURITY_BREACH)
				newMsg.title += "Security breach on [affected_dest.name]"
				newMsg.body = "There was [pick("a security breach in","an unauthorized access in","an attempted theft in","an anarchist attack in","violent sabotage of")] a [pick("high-security","restricted access","classified","\'REDACTED\'")] [pick("\'REDACTED\'","section","zone","area")] this morning. Security was tightened on [affected_dest.name] after the incident, and the editor reassures all Nanotrasen personnel that such lapses are rare."
			if(RANDOM_STORY_ANIMAL_RIGHTS_RAID)
				newMsg.title += "Animal rights raid on [affected_dest.name]"
				newMsg.body = "[pick("Militant animal rights activists","Members of the terrorist group Animal Rights Consortium","Members of the terrorist group \'REDACTED\'")] have [pick("launched a campaign of terror","unleashed a swathe of destruction","raided farms and pastures","forced entry to \'REDACTED\'")] on [affected_dest.name] earlier today, freeing numerous [pick("farm animals","animals","\'REDACTED\'")]. Prices for tame and breeding animals have spiked as a result."
			if(RANDOM_STORY_FESTIVAL)
				newMsg.title += "Festival on [affected_dest.name]"
				newMsg.body = "A [pick("festival","week long celebration","day of revelry","planet-wide holiday")] has been declared on [affected_dest.name] by [pick("Governor","Commissioner","General","Commandant","Administrator")] [random_name(pick(MALE,FEMALE))] to celebrate [pick("the birth of their [pick("son","daughter")]","coming of age of their [pick("son","daughter")]","the pacification of rogue military cell","the apprehension of a violent criminal who had been terrorizing the planet")]. Massive stocks of food and meat have been bought driving up prices across the planet."
			else
				newMsg.title = null // let newscaster autogenerate a title

	GLOB.news_network.get_channel_by_name("Nyx Daily")?.add_message(newMsg)
	for(var/nc in GLOB.allNewscasters)
		var/obj/machinery/newscaster/NC = nc
		NC.alert_news(newMsg.title)

/datum/event/economic_event/end()
	for(var/good_type in dearer_goods)
		affected_dest.temp_price_change[good_type] = 1
	for(var/good_type in cheaper_goods)
		affected_dest.temp_price_change[good_type] = 1
