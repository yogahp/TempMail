require 'net/http'
require 'json'
require 'digest'
require 'tempmail/host'

module TempMail
  class Client
    def available_domains
      response = get_response(uri: "#{host}/request/domains/format/json/")
      parsing_json(response_body: response.body, symbolize_names: true)
    end

    def incoming_emails(email)
      hash = Digest::MD5.hexdigest(email)
      response = get_response(uri: "#{host}/request/mail/id/#{hash}/format/json/")
      puts response.body 

      if response.is_a?(Net::HTTPNotFound)
        []
      else
        parsing_json(response_body: response.body, symbolize_names: true)
      end
    rescue
      response = get_response(uri: "#{host}/request/mail/id/#{hash}/format/json/")
      parsing_json(response_body: response.body, symbolize_names: true)
    end

    private

    def host
      TempMail::Host::NAME
    end

    def get_response(params)
      uri = params[:uri]
      response = Net::HTTP.get_response(URI(uri))
      return response
    end

    def parsing_json(params)
      response_body = params[:response_body]
      symbolize_names = params[:symbolize_names]

      JSON.parse(response_body, symbolize_names: symbolize_names)
    end
  end
end
