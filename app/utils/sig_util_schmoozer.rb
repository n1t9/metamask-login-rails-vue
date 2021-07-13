require 'schmooze'

class SigUtilSchmoozer < Schmooze::Base
  dependencies sigUtil: 'eth-sig-util'

  method :recover_personal_signature, 'sigUtil.recoverPersonalSignature'
end
