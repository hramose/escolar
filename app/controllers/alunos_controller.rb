class AlunosController < ApplicationController
	before_filter :find_aluno, :only => [:edit, :update]

	def suggest
		@busca = params[:aluno][:nome_ou_subscricao]
		begin
			Integer(@busca)
			@alunos = current_escola.alunos.all(:conditions => {:subscricao => @busca})
		rescue
			@alunos = current_escola.alunos.all(:conditions => ["nome LIKE ?", "%#{@busca}%"], :limit => 10)
		end
	end

	def index
		@alunos = current_escola.alunos.all
	end

	def new
		@aluno = current_escola.alunos.new
	end
  
  def edit
  	@endereco_residencial = @aluno.endereco_residencial
  	@endereco_comercial = @aluno.endereco_comercial
  end

  def update
	@endereco_residencial = Endereco.new(params[:endereco_residencial])
	@aluno.endereco_residencial = @endereco_residencial.vazio? ? nil : @endereco_residencial

	@endereco_comercial = Endereco.new(params[:endereco_comercial])
	@aluno.endereco_comercial = @endereco_comercial.vazio? ? nil : @endereco_comercial

    @aluno.update_attributes(params[:aluno])
    redirect_to alunos_path
  rescue RecordNotSaved
  	render :action => :edit
  end

  def create
	@aluno = current_escola.alunos.build(params[:aluno])
	@endereco_residencial = Endereco.new(params[:endereco_residencial])
	@aluno.endereco_residencial = @endereco_residencial.vazio? ? nil : @endereco_residencial

	@endereco_comercial = Endereco.new(params[:endereco_comercial])
	@aluno.endereco_comercial = @endereco_comercial.vazio? ? nil : @endereco_comercial

    @aluno.save!
    redirect_to alunos_path
  rescue RecordNotSaved
  	render :action => :new
  end

	private
	def find_aluno
		@aluno = current_escola.alunos.find params[:id]
	end
end