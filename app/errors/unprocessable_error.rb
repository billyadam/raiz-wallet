class UnprocessableError < StandardError
    def initialize(message)
        super(message)
    end
end