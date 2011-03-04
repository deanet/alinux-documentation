module Rack
  
  # Automatically redirects to the configurable domain
  #
  # If request comes from other than specified domains it redirects to the first
  # domain from the list
  class DomainRedirect
    
    def initialize(app, hosts = [])
      @app = app
      @hosts = hosts
    end
    
    def call(env)
      req = Rack::Request.new(env)
      
      if @hosts.nil? or @hosts.empty? or @hosts.include?(req.host)
        @app.call(env)
      else
        url = "http://#{@hosts[0]}"
        # url << ":#{req.port}" unless req.port == 80
        url << "#{req.path}"
        url << "?#{req.query_string}" unless req.query_string.empty?
        res = Rack::Response.new
        res.redirect(url)
        res.finish
      end
    end
  end
end
