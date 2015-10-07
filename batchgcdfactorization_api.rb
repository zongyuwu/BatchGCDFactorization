#!/usr/bin/env ruby

require 'openssl'
$FastGCD_PATH = "#{Dir.pwd}/fastgcd/"

class Batchgcd
  def initialize(n_arr=nil)
    @N_arr = []
    @N_arr += n_arr.to_a if n_arr!=nil
  end

  def update(n_v)
    puts "update"
    @N_arr << n_v.to_i
  end

  def update_from_file(file_name)
    rsa = OpenSSL::PKey::RSA.new file_name
    @N_arr << rsa.params["n"].to_i
  end

  def exploit
    write_file("#{$FastGCD_PATH}input.moduli")
    `#{$FastGCD_PATH}fastgcd #{$FastGCD_PATH}input.moduli`
    puts "\n\nDone...."
    puts "The vulnerabe modulus is in #{Dir.pwd}vulnerable_moduli"
    puts "The gcd of  modulus is in #{Dir.pwdk}gcds"
  end

private
  def write_file(filepath)
    p @N_arr
    File.delete(filepath) if File.exist?(filepath)
    File.open(filepath, "w") do |f| 
      @N_arr.each do |e|
        f.puts (e.to_s(16))
      end
    end
  end
end

=begin
p1=12603778148798544648857436865265671338941510312429862633103578773936931010956443234206138462535483007903485634657616569358065317510437851839957110388287343
q1=10407537115105806518120991558880371634813945580996909309790362143722033536697540208850161280112808430556909364583555237441238550846836362257051582075398923
q2=12988174822518380325897991533448405226469665291375226021009975676939707115688279392023346316152170994600325685893698857498608755785862383431431415454287063
q3=11043513053762460885638195507321129837585375371403999430366591428350787368156251024841543520764316398274090870912803926123558151190385600558714575053664807
q4=11013467482370896127507538954922489800627220502894458922902943078668874368299099251148714754924030143032074133968928089993085306508951690767200743985442099

bgcd = Batchgcd.new([p1*q1, p1*q2])
bgcd.update(p1*q3)
bgcd.update(p1*q4)
bgcd.update(q1*q4)
bgcd.update_from_file("./test.pem")
puts bgcd.exploit
=end
