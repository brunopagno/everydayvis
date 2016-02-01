class SmadaController < ApplicationController

  def dados
    @dados = []
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE timestamp > ? AND sub_sensor_id = ?", Date.new(2014, 1, 1), 1)
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE timestamp > ? AND sub_sensor_id = ?", Date.new(2014, 1, 1), 2)
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE timestamp > ? AND sub_sensor_id = ?", Date.new(2014, 1, 1), 3)
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE timestamp > ? AND sub_sensor_id = ?", Date.new(2014, 1, 1), 4)
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE timestamp > ? AND sub_sensor_id = ?", Date.new(2014, 1, 1), 5)
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE timestamp > ? AND sub_sensor_id = ?", Date.new(2014, 1, 1), 6)
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE timestamp > ? AND sub_sensor_id = ?", Date.new(2014, 1, 1), 7)
  end

end
