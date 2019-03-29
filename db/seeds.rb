DatabaseCleaner.clean_with(:truncation, except: %w[admin_users])
AdminUser.first_or_create(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# stlpec_spravne a stlpec_client - 0 based, A=0, B=1, C=2, D=3, E=4, F=5, G=6, H=7, I=8, J=9, ...

h = Subtest.create(pismeno: 'H', popis: 'Affect understanding', filename: 'H_Affect understanding.txt', stlpec_spravne: 9, stlpec_client: 7)
i = Subtest.create(pismeno: 'I', popis: 'Affect expression', filename: 'I_Affect expression.txt', stlpec_spravne: 8, stlpec_client: 3)

dropbox = DropboxApi::Client.new('iWCZek45F1AAAAAAAABAdDkFN8rQUi2BItdN-6o86i1cbRmusBjwY19d1Kxpu7Uo')

def get_file(dropbox, path)
  file = ''
  dropbox.download(path) do |chunk|
    file << chunk.force_encoding('iso-8859-2').encode('utf-8')
  end
  file
end

dropbox.list_folder('/PEPS-C_2015_UKGen').entries.map(&:name).filter{|name| /^[\d_]*$/.match? name}.each do |client_folder|
  attrs = get_file(dropbox,"/PEPS-C_2015_UKGen/#{client_folder}/Client.cln")
                   .split("\n")
                   .filter{|line| line.include? '='}
                   .map{|line| line.split('=', -1)}
                   .to_h
  meno = attrs['GivenNames'].strip
  priezvisko = attrs['FamilyName'].strip
  client = Client.create(meno: meno, priezvisko: priezvisko, folder: client_folder, rodne_cislo: /(\d*)_/.match(client_folder).captures.first)
  puts client.display_name

  dropbox.list_folder("/PEPS-C_2015_UKGen/#{client_folder}/Results").entries.map(&:name).each do |test_set_folder|
    puts "    #{test_set_folder}"
    task_file_names = dropbox.list_folder("/PEPS-C_2015_UKGen/#{client_folder}/Results/#{test_set_folder}").entries.map(&:name).filter{|name| /^[A-Z]/.match? name}
    Subtest.all.each do |subtest|
      task_file_names.select{|f| f == subtest.filename}.each do |filename|
        puts "        #{filename}"
        file = get_file(dropbox, "/PEPS-C_2015_UKGen/#{client_folder}/Results/#{test_set_folder}/#{filename}")
        body = subtest.vyhodnot(file)
        datum = /Date=(\d\d\/\d\d\/\d\d\d\d)/.match(file).captures.first
        client.performances.create(subtest: subtest, body: body, datum: Date.parse(datum))
      end
    end
  end

  pp
end
