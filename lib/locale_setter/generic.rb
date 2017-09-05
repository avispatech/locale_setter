module LocaleSetter
  module Generic

    def self.set_locale(i18n, options = {:params => nil,
                                         :user   => nil,
                                         :domain => nil,
                                         :http   => nil})
      order = options.keys
      
      res = nil
      order.each do |meth|
        r = self.send("from_#{meth}".to_sym, options[meth], available(i18n))
        res = r and break if r.present?
      end
      
      i18n.locale = res || i18n.default_locale
    end

    def self.available(i18n)
      i18n.available_locales.map(&:to_s)
    end

    def self.from_user(user, available)
      LocaleSetter::User.for(user, available)
    end

    def self.from_http(env, available)
      if env && env["HTTP_ACCEPT_LANGUAGE"]
        LocaleSetter::HTTP.for(env["HTTP_ACCEPT_LANGUAGE"], available)
      end
    end

    def self.from_domain(domain, available)
      LocaleSetter::Domain.for(domain, available)
    end

    def self.from_params(params, available)
      if params && params[LocaleSetter.config.url_param]
        LocaleSetter::Param.for(params[LocaleSetter.config.url_param], available)
      end
    end
  end
end
