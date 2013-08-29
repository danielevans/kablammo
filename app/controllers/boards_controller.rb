class BoardsController
  def initialize(app)
    @app = app
  end

  def reset(name)
    board = Board.find_by_name name
    board.destroy if board

    board = Board.create({
      name: name,
      height: 9,
      width: 16
    })

    6.times { board.add_wall }
    board.add_tank( new_tank 'mwynholds' )
    board.add_tank( new_tank 'dhendee' )
    board.add_tank( new_tank 'carbonfive' )
    board.save!

    @app.redirect "/boards/#{name}"
  end

  def show(name)
    board = Board.find_by_name name
    return [404, "Unknown board: #{name}"] unless board
    json = jbuilder :board, locals: { board: board }
    erb :board, locals: { board: board, json: json }
  end

  def turn(name)
    board = Board.find_by_name name
    board.turn if board
    jbuilder :board, locals: { board: board }
  end

  private

  def new_tank(name)
    tank = Tank.new
    tank.username = name
    tank
  end

  def erb(*args)
    @app.erb(*args)
  end

  def jbuilder(*args)
    @app.jbuilder(*args)
  end
end
