const PostFlags = {};

PostFlags.init = function () {
  if (PostFlags._initialized) return;
  PostFlags._initialized = true;

  for (const container of $(".post-flag-note")) {
    if (container.clientHeight > 72) $(container).addClass("expandable");
  }

  $(".post-flag-note-header").on("click", (event) => {
    $(event.currentTarget).parents(".post-flag-note").toggleClass("expanded");
  });

  // Section: require flag note
  const flagReasonLabels = document.querySelectorAll(".flag-reason-label");
  const noteField = document.getElementById("flag_note_field");

  // single-form resolution
  const form = noteField?.closest("form") || document.querySelector(".flag-dialog-body form");

  if (noteField) {
    const notesContainer = noteField.closest(".flag-notes");
    const label = notesContainer?.querySelector("label[for=\"flag_note_field\"]") || notesContainer?.querySelector("label");
    const indicator = notesContainer?.querySelector(".required-indicator");

    if (label && indicator && !label.contains(indicator)) {
      label.appendChild(indicator);
    }
  }

  function updateNoteRequired() {
    if (!noteField) return;
    const selected = document.querySelector("input[name=\"post_flag[reason_name]\"]:checked");
    const notesContainer = noteField.closest(".flag-notes");
    const label = notesContainer?.querySelector("label");
    const indicator = label?.querySelector(".required-indicator") || notesContainer?.querySelector(".required-indicator");

    const requires = (selected?.dataset?.requireExplanation || "").trim().toLowerCase() === "true";
    noteField.required = !!requires;
    if (indicator) indicator.hidden = !requires;
  }

  if (form) {
    form.addEventListener("submit", (e) => {
      updateNoteRequired();
      if (e.submitter) e.submitter.disabled = true;
    });
  }

  const flagReasonContainer = document.querySelector(".flag-reason");
  if (flagReasonContainer) {
    flagReasonContainer.addEventListener("change", (e) => {
      if (!e.target || e.target.name !== "post_flag[reason_name]") return;
      flagReasonLabels.forEach(l => l.classList.remove("selected"));
      const parentLabel = e.target.closest(".flag-reason-label");
      if (parentLabel) parentLabel.classList.add("selected");
      updateNoteRequired();
    });
  }

  updateNoteRequired();
};

export default PostFlags;

$(() => {
  PostFlags.init();
});

