
module ActionMailerBaseExtensions
  def deliver_with_stealth!(mail=nil)
    mail ||= instance_variable_get(:@mail)
    if ::RedmineStealth.cloaked?
      if logger && mail
        logger.info("Squelching notification: #{mail.subject}")
      end
    else
      deliver_without_stealth!(mail)
    end
  end
end

module ActionMailer
  class Base
    include ActionMailerBaseExtensions
    alias_method_chain :deliver!, :stealth
  end
end

