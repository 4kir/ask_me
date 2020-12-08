class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, except: [:create]

  def edit
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to user_path(@question.user), notice: 'Вопрос задан'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to user_path(@question.user), notice: 'Вопрос сохранен'
    else
      render :edit
    end
  end

 def destroy
  # Перед тем, как удалять вопрос, сохраним пользователя, чтобы знать, куда
  # редиректить после удаления
  user = @question.user
  @question.destroy
  redirect_to user_path(user), notice: 'Вопрос удален :('
end

  private
   
    def load_question
      @question = Question.find(params[:id])
    end

    def authorize_user
      reject_user unless @question.user == current_user
    end

    def question_params
      params.require(:question).permit(:user_id, :text, :answer)
    end
end
