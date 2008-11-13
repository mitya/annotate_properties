module AnnotateProperties
  module_function
  
  def annotate(model_file)
    table = File.basename(model_file, '.rb').tableize
    print "Annotating %-30s" % "#{table}..."
    annotation = build_annotation(table)
    write_annotation(table.classify, model_file, annotation)
    puts ' done'
  rescue NameError, TypeError => e
    puts " skip (#{e})"
  end

  def build_annotation(table)
    klass = table.classify.constantize
    raise TypeError, 'not an ActiveRecord class' unless klass < ActiveRecord::Base
    raise TyperError, 'abstract class' if klass.abstract_class?
    name_len = klass.column_names.map(&:length).max + 1
    klass.columns.map do |col|
      options = []
      options << ":null => false" if !col.null
      options << ":pk => true" if col.primary
      options << ":precision => #{col.precision}, :scale => #{col.scale}" if col.precision && col.scale
      options << ":limit => #{col.limit}" if col.limit && ![:integer, :decimal, :boolean].include?(col.type)
      options << ":default => #{quote(col.default)}" if col.default
      "  property :%-#{name_len}s :%-9s %s\n" % ["#{col.name},", "#{col.type}" + (options.blank?? "" : ","), options.join(', ')]
    end.join.chomp
  end

  def write_annotation(klass_name, file, annotation)
    content = File.read(file)
    content.gsub!(/^\s*property :\w+,.*?\n/m, '')
    content.sub!(/^\s*class #{klass_name} .*$/, "\\0\n" + annotation)
    File.open(file, 'w') { |f| f.puts content }
  end
  
  def quote(value)
    value = case value
    when BigDecimal
      value.to_s('F')
    when Time, Date
      value.to_s(:db)
    else
      value
    end
    value.is_a?(String) ? "'#{value}'" : value
  end
end