require 'schmooze'

class BabelSchmoozer < Schmooze::Base
  dependencies sigUtil: 'eth-sig-util'

  method :recoverPersonalSignature, 'sigUtil.recoverPersonalSignature'
end
