class ImageForProductTag < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    unless markup.empty?
      @attributes = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end
    end

    @attributes['item'] ||= 'product'

  end

  def render(context)
    @result = context.registers[:action_view].send("#{@attributes['style']}_image".to_sym, resolve_value(@attributes['item'], context) )
    super(context)
  end
end

Liquid::Template.register_tag('image_for_product_tag', ImageForProductTag)

########################################################################################################################


class ProductImageUrlTag < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    unless markup.empty?
      if markup =~ /style:([-_a-z0-9]+)/
        @style = $1
      end

      if markup =~ /object:([-_a-z0-9]+)/
        @object = $1
      end
    end

    @object ||= 'product'

  end

  def render(context)
    @result = context[@object].source.images.first.attachment.url(@style.to_sym)
    super(context)
  end
end

Liquid::Template.register_tag('product_image_url_tag', ProductImageUrlTag)

########################################################################################################################

class GetProductsTag < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    unless markup.empty?
      if markup =~ /per_page:(\d+)/
        @per_page = $1.to_i
      end

      if markup =~ /type:([-_a-z0-9]+)/
        @type = $1
      end
    end

    @per_page ||= 5

  end

  def render(context)
    context.registers[:controller].params[:per_page] = @per_page
    @searcher = Spree::Config.searcher_class.new(context.registers[:controller].params)
    @searcher.current_user = context.registers[:controller].try_spree_current_user
    @searcher.current_currency = context.registers[:action_view].current_currency
    @result = @searcher.retrieve_products

    super(context)
  end
end

Liquid::Template.register_tag('get_products_tag', GetProductsTag)
########################################################################################################################


class ProductsByTaxonTag < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    unless markup.empty?
      if markup =~ /per_page:(\d+)/
        @per_page = $1.to_i
      end

      if markup =~ /taxon:([\/-_a-z0-9]+)/
        @taxon_name = $1
      end

      if markup =~ /type:([_a-z0-9]+)/
        @type = $1
      end
    end

    @per_page ||= 5

  end

  def render(context)
    @taxon = Spree::Taxon.find_by_permalink!(@taxon_name)
    return unless @taxon

    context[@taxon_name] = @taxon

    @searcher = Spree::Config.searcher_class.new(context.registers[:controller].params.merge(:taxon => @taxon.id))
    @searcher.current_user = context.registers[:controller].spree_current_user
    @searcher.current_currency = Spree::Config[:currency]
    @products = @searcher.retrieve_products

    @result = @products.per(@per_page)
    context['products'] = @products.per(@per_page)

    super(context)
  end
end

Liquid::Template.register_tag('products_by_taxon_tag', ProductsByTaxonTag)

########################################################################################################################

class PromoCountTag < Liquid::Tag

  def render(context)
    Spree::Promotion.count
    super(context)
  end
end

Liquid::Template.register_tag('promotion_count_tag', PromoCountTag)

########################################################################################################################


class SpreeSearchFormTag < Liquid::Tag

  def render(context)
    @result = context.registers[:action_view].render(:partial => 'spree/shared/search')
    super(context)
  end
end

Liquid::Template.register_tag('spree_search_form_tag', SpreeSearchFormTag)

########################################################################################################################
class ProductsFiltersTag < Liquid::Tag
  def render(context)
    # imported from spree/shared/_filters.html.erb
    template = context.registers[:action_view]
    filters = context['taxon'] ? context['taxon'].source.applicable_filters : [::Spree::ProductFilters.all_taxons]
    template.params[:search] ||= {}
    @result = context['filters'] = filters.map { |filter|
      filter[:labels] || filter[:conds].map { |m, c| [m, m] }
      filter[:inputs] = []
      next if filter[:labels].empty?
      filter[:labels] = filter[:labels].map do |nm, val|
        label = "#{filter[:name]}_#{nm}".gsub(/\s+/, '_')
        filter[:inputs] << template.tag(
            :input,
            :type => 'checkbox',
            :id => label,
            :name => "search[#{filter[:scope].to_s}][]",
            :value => val,
            :checked => (template.params[:search][filter[:scope]] && template.params[:search][filter[:scope]].include?(val.to_s))
        )
        template.content_tag(:label, :for => label) do
          nm
        end
      end
      filter.stringify_keys
    }
    super(context)
  end
end

Liquid::Template.register_tag('products_filters_tag', ProductsFiltersTag)

########################################################################################################################

class GetTaxonomiesTag < Liquid::Tag

  def render(context)
    @result = Spree::Taxonomy.includes(:root => :children).to_a

    super(context)
  end
end

Liquid::Template.register_tag('get_taxonomies_tag', GetTaxonomiesTag)

########################################################################################################################

class GetTaxonsTreeTag < Liquid::Tag

  def render(context)
    @resolved_attributes = {}
    @attributes.each_pair  do |key, value|
      @resolved_attributes[key] = resolve_value(value, context)
    end

    @result = context.registers[:action_view].taxons_tree(@resolved_attributes['root_taxon'], @resolved_attributes['current_taxon'], @resolved_attributes['max_level'])

    super(context)
  end
end

Liquid::Template.register_tag('get_taxons_tree_tag', GetTaxonsTreeTag)

########################################################################################################################

class GetSeoUrlTag < Liquid::Tag

  def render(context)
   @result = context.registers[:action_view].seo_url( resolve_value(@attributes['taxon'], context) )

    super(context)
  end
end

Liquid::Template.register_tag('get_seo_url_tag', GetSeoUrlTag)

########################################################################################################################

class VariantsAndOptionValuesTag < Liquid::Tag

  def render(context)
    @result = []
    context['product'].source.variants_and_option_values(Spree::Config[:currency]).each_with_index do |variant, index|
      @result << {'variant' => variant, 'index' => index}
    end

    super(context)
  end
end

Liquid::Template.register_tag('variants_and_option_values_tag', VariantsAndOptionValuesTag)

########################################################################################################################

class VariantPriceTag < Liquid::Tag

  def render(context)
    return '' unless @attributes['variant']
    @result = context.registers[:action_view].variant_price(@attributes['variant'])

    super(context)
  end
end

Liquid::Template.register_tag('variant_price_tag', VariantPriceTag)

########################################################################################################################

class ProductImagesTag < Liquid::Tag

  def render(context)
    return '' unless @attributes['product']
    @result = {'product_images' => [], 'variant_images' => []}
    product = context[@attributes['product']].source
    styles = Spree::Image.attachment_definitions[:attachment][:styles]
    styles['original'] = ''

    if (product.images + product.variant_images).uniq.size > 1
      product.images.each do |i|
        @result['product_images'] << styles.inject({}) do |hash, ob|
          hash[ob.first.to_s] = i.attachment.url(ob.first.to_sym)
          hash
        end
      end

      if product.has_variants?
        product.variant_images.each do |i|
          next if product.images.include?(i)
          @result['variant_images'] << styles.inject({}) do |hash, ob|
            hash[ob.first.to_s] = i.attachment.url(ob.first.to_sym)
            hash
          end
        end
      end
    end

    super(context)
  end
end

Liquid::Template.register_tag('product_images_tag', ProductImagesTag)