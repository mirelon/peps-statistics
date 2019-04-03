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
          panel "Performance on #{subtest.pismeno} subtest" do
            scatter_chart subtest.data_for_scatter_chart, xtitle: 'Vek', ytitle: 'Body', library: {scales: {
                xAxes: [{gridLines: {drawOnChartArea: true}, ticks: {stepSize: 1}}],
                yAxes: [{ticks: {stepSize: 1}}]
            }}
          end
        end
      end
    end
  end
end
