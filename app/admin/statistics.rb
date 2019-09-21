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
              scatter_chart subtest.data_for_combo_chart, max: 16, xtitle: 'Vek', ytitle: 'Body', library: {scales: {
                  xAxes: [{gridLines: {drawOnChartArea: true}, ticks: {stepSize: 1}}],
                  yAxes: [{ticks: {stepSize: 1}}]
              }}
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
                require 'descriptive_statistics/safe'
                performances.extend(DescriptiveStatistics)
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
