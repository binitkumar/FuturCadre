module ApplicationHelper
  def escape_single_quotes(x)
      return x.gsub(/'/, "\\\\'")
  end
end
