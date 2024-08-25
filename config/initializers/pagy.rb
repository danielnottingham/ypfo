# frozen_string_literal: true

require "pagy/extras/metadata"
require "pagy/extras/array"
require "pagy/extras/overflow"

Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:limit] = 50
