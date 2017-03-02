require 'net/http'
require 'yaml'
require 'json'

CLOUDFLARE_API_URL_BASE = "https://api.cloudflare.com/client/v4/"

def parse_config
    $config = YAML.load File.open('config.yml')
end

def get_zone_identifier(domain)
    uri = URI("#{CLOUDFLARE_API_URL_BASE}/zones?name=#{domain}")
    req = Net::HTTP::Get.new(uri)

    req['X-Auth-Key'] = $config['cloudflare-cendentials']['api_key']
    req['X-Auth-Email'] = $config['cloudflare-cendentials']['email']
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(req)
    }
    json = JSON.parse(res.body)
    if json['success'] == true
        json['result'][0]['id']
    else
        nil
    end
end

def get_record_identifier(zone, name)
    uri = URI("#{CLOUDFLARE_API_URL_BASE}/zones/#{zone}/dns_records?name=#{name}")
    req = Net::HTTP::Get.new(uri)

    req['X-Auth-Key'] = $config['cloudflare-cendentials']['api_key']
    req['X-Auth-Email'] = $config['cloudflare-cendentials']['email']
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(req)
    }
    json = JSON.parse(res.body)
    if json['success'] == true
        json['result']
    else
        nil
    end
end

def check_domain_ip(domain, ip)
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.head('/index.html')
    }

parse_config
zone = get_zone_identifier("jie.today")
puts get_record_identifier(zone, 'aandg.jie.today')