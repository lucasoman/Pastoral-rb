synonyms = {
  :g => :go,
  :walk => :go,
  :wander => :go,
  :l => :look,
  :inspect => :look,
  :survey => :look,
  :n => :name,
  :nick => :name,
  :y => :yell,
  :scream => :yell,
  :holler => :yell,
  :ooc => :yell,
  :q => :quit,
  :leave => :quit,
  :disconnect => :quit,
  :exit => :quit,
  :logout => :quit,
	:i => :inventory,
	:inv => :inventory
  }
synonyms.each {|s,m| Handler.addSynonym(m,s) }

