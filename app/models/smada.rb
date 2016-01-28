class Dados < ActiveRecord::Base

  @conn = ActiveRecord::Base.establish_connection(
    :adapter  => "postgresql",
    :host     => "localhost",
    :database => "sensordata"
  )

  def dados
    @conn.connection.execute("select * from dados")
  end

end
