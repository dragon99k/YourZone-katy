class ListWordFoundsController < ApplicationController

  def index
    list_word_founds = ListWordFound.all

    respond_to do |format|
      format.json { render :json => {data: list_word_founds}}
    end
  end
end
