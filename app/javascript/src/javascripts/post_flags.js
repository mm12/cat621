const PostFlags = {};

PostFlags.init = function () {
  if (PostFlags._initialized) {
    return;
  }
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
  const radioButtons = document.getElementsByName("post_flag[reason_name]");
  let form = null;
  if (noteField) {
    form = noteField.closest("form");
  } else {
    const dialogBody = document.querySelector(".flag-dialog-body");
    if (dialogBody) {
      form = dialogBody.querySelector("form");
    }
  }

  if (noteField) {
    const notesContainer = noteField.closest(".flag-notes");
    const label = notesContainer?.querySelector("label[for=\"flag_note_field\"]") || notesContainer?.querySelector("label");
    let indicator = notesContainer?.querySelector(".required-indicator");

    if (label && !label.querySelector(".required-indicator")) {
      if (indicator && !label.contains(indicator)) {
        label.appendChild(indicator);
      }
    }
  }

  function updateNoteRequired () {
    if (!noteField) return;
    const selected = document.querySelector("input[name=\"post_flag[reason_name]\"]:checked");
    const notesContainer = noteField.closest(".flag-notes");
    const label = notesContainer?.querySelector("label");
    const indicator = label?.querySelector(".required-indicator") || notesContainer?.querySelector(".required-indicator");

    if (selected && (selected.dataset.requireExplanation || "").trim().toLowerCase() === "true") {
      noteField.required = true;
      if (indicator) {
        indicator.hidden = false;
      }
    } else {
      noteField.required = false;
      if (indicator) {
        indicator.hidden = true;
      }
    }
  }

  if (form) {
    form.addEventListener("submit", function (e) {
      updateNoteRequired();
      if (e.submitter) {
        e.submitter.disabled = true;
      }
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
    Array.from(radioButtons).forEach(radio => {
      radio.addEventListener("change", updateNoteRequired);
    });
  }

  updateNoteRequired();
};

export default PostFlags;

$(() => {
  PostFlags.init();
});

