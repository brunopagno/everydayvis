class SmadaController < ApplicationController

  def dados
    @dados = Smada.conn.execute("SELECT * FROM dados")
  end

end
