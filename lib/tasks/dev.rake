namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando Banco de Dados") { %x(rails db:drop) }
      show_spinner("Criando Banco de Dados") { %x(rails db:create) }
      show_spinner("Migrando Banco de Dados") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
      
    end
  end

desc "Cadastra as moedas"
task add_coins: :environment do
  show_spinner("Cadastrando moedas...") do
    spinner = TTY::Spinner.new("[:spinner] Cadastrando moedas...", format: :pulse_2)
    spinner.auto_spin 

    coins = [
    { 
      description: "Bitcoin",
      acronym: "BTC",
      url_image: "https://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png",
      mining_type: MiningType.find_by(acronym: 'PoW')
    },
    {
      description: "Ethereum",
      acronym: "ETH",
      url_image: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/ETHEREUM-YOUTUBE-PROFILE-PIC.png/600px-ETHEREUM-YOUTUBE-PROFILE-PIC.png",
      mining_type: MiningType.all.sample
    },
    {
      description: "Dash",
      acronym: "DASH",
      url_image: "https://www.iconfinder.com/data/icons/crypto-currency-and-coin-2/256/dash_dashcoin-512.png",
      mining_type: MiningType.all.sample
    }
    ]

    coins.each do |coin| 
    Coin.find_or_create_by!(coin)
    end
  end
end

desc "Cadastro dos tipos de mineração"
task add_mining_types: :environment do 
  show_spinner("Cadastrando tipos de mineração...") do
  spinner = TTY::Spinner.new("[:spinner] Cadastrando tipos de mineração...", format: :pulse_2)
  spinner.auto_spin 
    mining_types = [
      { description: "Proof os Work", acronym: "PoW" },
      { description: "Proof os Stake", acronym: "PoS" },
      { description: "Proof os Capacity", acronym: "PoC" }
    ]

    mining_types.each do |mining_type|
      MiningType.find_or_create_by!(mining_type)
    end
  end
end


private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :pulse_2)
    spinner.auto_spin 
    yield
    spinner.success("(#{msg_end})")
  end
end
