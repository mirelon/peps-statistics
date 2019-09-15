raise 'only_new must by one of: clients, performances' if ENV['only_new'] and not %w(clients performances).include? ENV['only_new']
DatabaseCleaner.clean_with(:truncation, except: %w[admin_users]) unless ENV['only_new']
AdminUser.first_or_create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# stlpec_spravne a stlpec_client - 0 based, A=0, B=1, C=2, D=3, E=4, F=5, G=6, H=7, I=8, J=9, ...

f = Subtest.where(pismeno: 'F').first_or_create!(pismeno: 'F', popis: 'Turn End understanding', filename: 'F_Turn End understanding.txt', stlpec_spravne: 7, stlpec_client: 5)
g = Subtest.where(pismeno: 'G').first_or_create!(pismeno: 'G', popis: 'Turn End expression', filename: 'G_Turn End expression.txt', stlpec_spravne: 2, stlpec_client: 4)
h = Subtest.where(pismeno: 'H').first_or_create!(pismeno: 'H', popis: 'Affect understanding', filename: 'H_Affect understanding.txt', stlpec_spravne: 9, stlpec_client: 7)
i = Subtest.where(pismeno: 'I').first_or_create!(pismeno: 'I', popis: 'Affect expression', filename: 'I_Affect expression.txt', stlpec_spravne: 8, stlpec_client: 3)
p = Subtest.where(pismeno: 'P').first_or_create!(pismeno: 'P', popis: 'Contrastive Stress understanding', filename: 'P_Contrastive Stress understanding.txt', stlpec_spravne: 7, stlpec_client: 5)
q = Subtest.where(pismeno: 'Q').first_or_create!(pismeno: 'Q', popis: 'Contrastive Stress expression', filename: 'Q_Contrastive stress expression.txt', stlpec_spravne: 2, stlpec_client: 6)

# dropbox = DropboxApi::Client.new('iWCZek45F1AAAAAAAABAdDkFN8rQUi2BItdN-6o86i1cbRmusBjwY19d1Kxpu7Uo')
#
# def get_file(dropbox, path)
#   file = ''
#   dropbox.download(path) do |chunk|
#     file << chunk.force_encoding('iso-8859-2').encode('utf-8')
#   end
#   file
# end
#
# client_folders_from_dropbox = dropbox.list_folder('/PEPS-C_2015_UKGen').entries.map(&:name).filter{|name| /^[\d_]*$/.match? name}
# client_folders_from_db = Client.all.map(&:folder).compact
# client_folders_to_process = if ENV['only_new'] == 'clients'
#                               client_folders_from_dropbox - client_folders_from_db
#                             else
#                               client_folders_from_dropbox
#                             end
# pp client_folders_from_dropbox
# pp client_folders_from_db
# puts "Processing #{client_folders_to_process.size} folders from dropbox: #{client_folders_to_process}"
# client_folders_to_process.each do |client_folder|
#   attrs = get_file(dropbox,"/PEPS-C_2015_UKGen/#{client_folder}/Client.cln")
#                    .split("\n")
#                    .filter{|line| line.include? '='}
#                    .map{|line| line.split('=', -1)}
#                    .to_h
#   meno = attrs['GivenNames'].strip
#   priezvisko = attrs['FamilyName'].strip
#   sex = case attrs['Sex'].strip
#         when '1'
#           'M'
#         when '2'
#           'F'
#         end
#   rodne_cislo = attrs['ID'].strip
#   client = Client.where(folder: client_folder).first_or_create!(meno: meno, priezvisko: priezvisko, sex: sex, folder: client_folder, rodne_cislo: rodne_cislo)
#   puts client.display_name
#
#   dropbox.list_folder("/PEPS-C_2015_UKGen/#{client_folder}/Results").entries.map(&:name).each do |test_set_folder|
#     puts "    #{test_set_folder}"
#     task_file_names = dropbox.list_folder("/PEPS-C_2015_UKGen/#{client_folder}/Results/#{test_set_folder}").entries.map(&:name).filter{|name| /^[A-Z]/.match? name}
#     Subtest.all.each do |subtest|
#       next if ENV['only_new'] == 'performances' and client.performances.where(subtest: subtest).count > 0
#       task_file_names.select{|f| f == subtest.filename}.each do |filename|
#         puts "        #{filename}"
#         file = get_file(dropbox, "/PEPS-C_2015_UKGen/#{client_folder}/Results/#{test_set_folder}/#{filename}")
#         body = subtest.vyhodnot(file)
#         datum = /Date=(\d\d\/\d\d\/\d\d\d\d)/.match(file).captures.first
#         client.performances.create(subtest: subtest, body: body, datum: Date.parse(datum))
#       end
#     end
#   end
#
#   (1..16).each do |i|
#     rc = ''
#     if i < 10
#       rc += '0'
#     end
#     rc += i.to_s
#     rc += '0101'
#     client = Client.create!(meno: "Test #{i}", priezvisko: "Test #{i}", sex: 'M', folder: nil, rodne_cislo: rc)
#     body = Random.rand(16-i..16)
#     client.performances.create(subtest: Subtest.first, body: body, datum: Date.current)
#   end
#
# end
