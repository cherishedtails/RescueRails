class AdopterSearcher
  STATUSES = ['new', 'pend response', 'workup', 'approved']

  def initialize(params: {})
    @params = params
  end

  def search
    @adopters = Adopter

    if name_search?
      @adopters = @adopters.where('adopters.name ILIKE ?', "%#{@params[:search].strip}%")
    elsif active_status_search?
      @adopters = @adopters.where('status IN (?)', STATUSES)
    elsif status_search?
      @adopters = @adopters.where(status: @params[:status])
    end

    with_includes

    @adopters
  end

  def self.search(params: {})
    self.new(params: params).search
  end

  private

  def with_includes
    @adopters = @adopters.includes(:user, :comments, :dogs, :adoption_app)
  end

  def active_status_search?
    @params[:status] == 'active'
  end

  def status_search?
    @params.has_key? :status
  end

  def name_search?
    @params[:search].present?
  end
end