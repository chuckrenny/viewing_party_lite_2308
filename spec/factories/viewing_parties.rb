FactoryBot.define do
  factory :viewing_party do
    duration { 120 } # assuming duration is in minutes
    day { Date.today }
    time { 20 }
    host_id { "" }
    association :movie_id, factory: :movie

    # after(:create) do |viewing_party|
    #   # Optionally create some party_users for the viewing_party
    #   create_list(:party_user, 3, viewing_party: viewing_party)
    # end
  end
end
