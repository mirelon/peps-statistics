ActiveAdmin.register_page 'Statistics' do
  menu priority: 1, label: 'Statistics'

  content title: 'Statistics' do
    columns do
      column do
        panel 'Recent clients' do
          ul do
            Client.last(5).map do |client|
              li link_to(client.display_name, admin_client_path(client))
            end
          end
        end
      end

      column do
        Subtest.all.each do |subtest|
          next if subtest.performances.size == 0
          subtest.calculate_logistic
          panel "Performance on #{subtest.pismeno} subtest" do
            div do
              filename = subtest.pismeno
              file = File.open("public/images/#{filename}", 'w')
              Numo.gnuplot do
                set xlabel: 'Vek'
                set xrange: subtest.logistic_data.xrange
                set ylabel: 'Body'
                set yrange: 0..16
                set title:"Subtest #{filename}"
                set output:file.path
                set terminal: 'pngcairo'
                set style: 'circle radius 0.1'
                set :grid
                run <<EOL
plot 8+8/(1+exp(#{subtest.function.scale}*(#{subtest.function.mean}-x))) with lines notitle, "-" using 1:2 with circles fill solid linecolor rgb "#0000ff" notitle
#{subtest.logistic_data.data.map{|array| array.join(' ')}.join("\n")}
e
EOL
              end
              image_tag filename, skip_pipeline: true
            end
            table class: 'statistics_summary' do
              tr do
                th 'Vek'
                th 'Počet'
                th 'Priemer'
                th 'SD'
              end
              body_s_vekmi = subtest.performances.joins(:client).pluck(:body, 'date_part(\'year\', age(performances.datum, clients.datum_narodenia))')
              body_s_vekmi.group_by{|bv| bv[1]}.sort.to_h.each do |age, performances|
                tr do
                  td age
                  td performances.count
                  td sprintf('%.2f', performances.mean{|bv| bv[0]})
                  td sprintf('%.2f', performances.standard_deviation{|bv| bv[0]})
                end
              end
            end
          end
        end
      end
    end
  end
end
