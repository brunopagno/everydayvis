class SmadaController < ApplicationController

  def dados
    @dados = []
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE sub_sensor_id = 1")
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE sub_sensor_id = 2")
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE sub_sensor_id = 3")
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE sub_sensor_id = 4")
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE sub_sensor_id = 5")
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE sub_sensor_id = 6")
    @dados << Smada.conn.execute("SELECT * FROM dados WHERE sub_sensor_id = 7")
  end

end
