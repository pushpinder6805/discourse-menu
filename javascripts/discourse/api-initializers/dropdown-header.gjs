import { apiInitializer } from "discourse/lib/api";
import CustomHeaderLinks from "../components/custom-header-links";

export default apiInitializer("1.29.0", (api) => {
  if (!settings.header_links) {
    return;
  }

  // Add the header dropdown links based on the setting position (right or left)
  if (settings.links_position === "right") {
    api.headerButtons.add("dropdown-header", CustomHeaderLinks, {
      before: "auth",
    });
  } else {
    api.renderAfterWrapperOutlet("home-logo", CustomHeaderLinks);
  }

  // Recursive rendering for submenus (and sub-submenus)
  const renderDropdownLinks = (link, depth = 1) => {
    const dropdown = document.createElement("ul");
    dropdown.classList.add(`submenu-level-${depth}`);

    link.dropdownLinks.forEach((subLink) => {
      const li = document.createElement("li");

      const anchor = document.createElement("a");
      anchor.href = subLink.url || "#";
      anchor.textContent = subLink.title;

      li.appendChild(anchor);

      // If there are sub-dropdown links, recursively render them
      if (subLink.subDropdownLinks && subLink.subDropdownLinks.length) {
        const subDropdown = renderDropdownLinks(subLink, depth + 1);
        li.appendChild(subDropdown);
      }

      dropdown.appendChild(li);
    });

    return dropdown;
  };

  // Hook the dropdown rendering function into the initialization process
  settings.header_links.forEach((link) => {
    if (link.dropdownLinks) {
      const dropdownMenu = renderDropdownLinks(link);
      document.querySelector(".header-dropdown").appendChild(dropdownMenu);
    }
  });
});
