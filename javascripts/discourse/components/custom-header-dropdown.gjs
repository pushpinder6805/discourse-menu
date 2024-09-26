import Component from "@ember/component";
import { fn } from "@ember/helper";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DiscourseURL from "discourse/lib/url";
import CustomIcon from "./custom-icon";

export default class CustomHeaderDropdown extends Component {
  @service site;
  @service router;

  // Action for redirecting when a menu item is clicked
  @action
  redirectToUrl(url, event) {
    if (this.site.mobileView) {
      this.toggleHeaderLinks();
    }

    DiscourseURL.routeTo(url);
    event.stopPropagation();
  }

  // Recursive method to render submenus
  renderSubMenu(item) {
    if (item.subDropdownLinks && item.subDropdownLinks.length > 0) {
      return (
        <ul class="sub-dropdown-menu">
          {item.subDropdownLinks.map((subItem) => (
            <li
              class="custom-header-submenu-link"
              title={subItem.title}
              role="button"
              {{on "click" (fn this.redirectToUrl subItem.url)}}
            >
              <CustomIcon @icon={{subItem.icon}} />
              <span class="custom-header-link-title">{{subItem.title}}</span>
              {{#if subItem.description}}
                <span class="custom-header-link-desc">{{subItem.description}}</span>
              {{/if}}
              {{this.renderSubMenu subItem}}
            </li>
          ))}
        </ul>
      );
    }
    return null;
  }

  <template>
    <li
      class="custom-header-dropdown-link"
      title={{@item.title}}
      role="button"
      {{on "click" (fn this.redirectToUrl @item.url)}}
    >
      <CustomIcon @icon={{@item.icon}} />
      <span class="custom-header-link-title">{{@item.title}}</span>
      {{#if @item.description}}
        <span class="custom-header-link-desc">{{@item.description}}</span>
      {{/if}}

      {{this.renderSubMenu @item}}
    </li>
  </template>
}
