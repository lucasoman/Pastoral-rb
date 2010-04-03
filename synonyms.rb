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
  :logout => :quit
  }
synonyms.each {|s,m| Handler.addSynonym(m,s) }

