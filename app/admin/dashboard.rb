ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do

    end

    columns do
      column do
        panel "Top 5 Companies" do
          ul do
            Company.recent(5).map do |post|
              li link_to(post.name, admin_company_path(post))
            end
          end
        end
      end

  
    end
  end # content
end
