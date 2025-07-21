Ransack.configure do |config|

  config.add_predicate 'cont', 
                       arel_predicate: 'matches',
                       formatter: proc { |v| "%#{v}%" },
                       validator: proc { |v| v.present? },
                       type: :string
end
