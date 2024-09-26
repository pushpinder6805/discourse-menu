import { tracked } from "@glimmer/tracking";
import Component from "@ember/component";
import { hash } from "@ember/helper";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import DButton from "discourse/components/d-button";
import concatClass from "discourse/helpers/concat-class";
import closeOnClickOutside from "discourse/modifiers/close-on-click-outside";
import i18n from "discourse-common/helpers/i18n";
import CustomHeaderLink from "./custom-header-link";

export default class CustomHeaderLinks extends Component {
  @service siteSettings;
  @service site;

  @tracked showLinks = !this.site.mobileView;

  @action
  toggleHeaderLinks() {
    this.showLinks = !this.showLinks;

    if (this.showLinks) {
      document.body.classList.add("dropdown-header-open");
    } else {
      document.body.classList.remove("dropdown-header-open");
    }
  }

  get headerLinks() {
    return JSON.parse(settings.header_links);
  }

  get subDropdownExists() {
    return this.headerLinks.some((item) =>
      item.dropdownLinks?.some((dropdownItem) => dropdownItem.subDropdownLinks)
    );
  }

  <template>
    <nav
      class={{concatClass
        "custom-header-links"
        (if @outletArgs.minimized "scrolling")
      }}
    >
      {{#if this.site.mobileView}}
        <span class="btn-custom-header-dropdown-mobile">
          <DButton
            @icon="caret-square-down"
            @title={{i18n "custom_header.discord"}}
            @action={{this.toggleHeaderLinks}}
          />
        </span>
      {{/if}}

      {{#if this.showLinks}}
        <ul
          class="top-level-links"
          {{(if
            this.site.mobileView
            (modifier
              closeOnClickOutside
              this.toggleHeaderLinks
              (hash target=this.element)
            )
          )}}
        >
          {{#each this.headerLinks as |item|}}
            <CustomHeaderLink
              @item={{item}}
              @toggleHeaderLinks={{this.toggleHeaderLinks}}
            />
            {{#if item.dropdownLinks}}
              <ul class="dropdown-links">
                {{#each item.dropdownLinks as |dropdownItem|}}
                  <CustomHeaderLink
                    @item={{dropdownItem}}
                    @toggleHeaderLinks={{this.toggleHeaderLinks}}
                  />
                  {{!-- Sub-submenu check --}}
                  {{#if dropdownItem.subDropdownLinks}}
                    <ul class="sub-dropdown-links">
                      {{#each dropdownItem.subDropdownLinks as |subDropdownItem|}}
                        <CustomHeaderLink
                          @item={{subDropdownItem}}
                          @toggleHeaderLinks={{this.toggleHeaderLinks}}
                        />
                      {{/each}}
                    </ul>
                  {{/if}}
                {{/each}}
              </ul>
            {{/if}}
          {{/each}}
        </ul>
      {{/if}}
    </nav>
  </template>
}
