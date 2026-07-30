(() => {
  "use strict";

  const header = document.querySelector("[data-header]");
  const menuButton = document.querySelector("[data-menu-button]");
  const menu = document.querySelector("[data-menu]");
  const form = document.querySelector("[data-estimate-form]");
  const imageInput = document.querySelector("[data-image-input]");
  const uploadText = document.querySelector("[data-upload-text]");
  const fileError = document.querySelector("[data-file-error]");
  const result = document.querySelector("[data-result]");
  const resultSummary = document.querySelector("[data-result-summary]");
  const resultPrice = document.querySelector("[data-result-price]");
  const resetButton = document.querySelector("[data-reset]");

  const prices = {
    "14K 골드": [420000, 680000],
    "18K 골드": [540000, 820000],
    "플래티넘": [690000, 1100000],
    "실버": [160000, 320000]
  };

  const formatWon = (value) => `${value.toLocaleString("ko-KR")}원`;

  document.querySelectorAll("[data-year]").forEach((node) => {
    node.textContent = new Date().getFullYear();
  });

  const updateHeader = () => header?.classList.toggle("scrolled", window.scrollY > 12);
  updateHeader();
  window.addEventListener("scroll", updateHeader, { passive: true });

  menuButton?.addEventListener("click", () => {
    const isOpen = menu.classList.toggle("open");
    menuButton.setAttribute("aria-expanded", String(isOpen));
  });

  menu?.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      menu.classList.remove("open");
      menuButton?.setAttribute("aria-expanded", "false");
    });
  });

  imageInput?.addEventListener("change", () => {
    const file = imageInput.files?.[0];
    fileError.textContent = "";
    if (!file) return;

    const allowedTypes = ["image/jpeg", "image/png", "image/webp"];
    if (!allowedTypes.includes(file.type)) {
      imageInput.value = "";
      fileError.textContent = "JPG, PNG, WEBP 이미지만 선택할 수 있습니다.";
      return;
    }

    if (file.size > 10 * 1024 * 1024) {
      imageInput.value = "";
      fileError.textContent = "파일 크기는 10MB 이하여야 합니다.";
      return;
    }

    uploadText.innerHTML = `<strong>${file.name}</strong><br>이미지가 준비되었습니다.`;
  });

  form?.addEventListener("submit", (event) => {
    event.preventDefault();
    const data = new FormData(form);
    const type = data.get("type");
    const material = data.get("material");
    const [minimum, maximum] = prices[material] ?? prices["14K 골드"];

    resultSummary.textContent = `${material} 소재의 ${type}를 기준으로 계산한 데모 견적입니다.`;
    resultPrice.textContent = `${formatWon(minimum)} ~ ${formatWon(maximum)}`;
    result.hidden = false;
    result.scrollIntoView({ behavior: "smooth", block: "center" });
  });

  resetButton?.addEventListener("click", () => {
    form.reset();
    imageInput.value = "";
    uploadText.innerHTML = "<strong>이미지 선택</strong><br>JPG, PNG, WEBP · 최대 10MB";
    fileError.textContent = "";
    result.hidden = true;
    document.querySelector("#estimate")?.scrollIntoView({ behavior: "smooth" });
  });
})();
