ActiveAdmin.register Client do
  permit_params :rodne_cislo, :folder, :meno, :priezvisko, :sex

  form do |f|
    f.inputs do
      f.input :rodne_cislo
      f.input :folder
      f.input :meno
      f.input :priezvisko
      f.input :sex, as: :select, collection: [:muz, :zena]
    end
    f.actions
  end
end
