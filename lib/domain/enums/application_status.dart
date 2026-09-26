/// Lifecycle of a job application.
///
/// Stored in the database by [name], so values may be reordered or added but
/// never renamed without a migration.
enum ApplicationStatus {
  saved('Saved', pipelineRank: 0),
  applied('Applied', pipelineRank: 1),
  screening('Screening', pipelineRank: 2),
  interview('Interview', pipelineRank: 3),
  technicalTest('Technical Test', pipelineRank: 4),
  offer('Offer', pipelineRank: 5),
  rejected('Rejected'),
  withdrawn('Withdrawn');

  const ApplicationStatus(this.label, {this.pipelineRank});

  final String label;

  /// Position in the hiring pipeline, or `null` for terminal outcomes
  /// ([rejected], [withdrawn]) that can happen at any stage.
  final int? pipelineRank;

  /// Whether the application has ended (no further progress expected).
  bool get isTerminal => pipelineRank == null;

  /// Whether this status is at or beyond [other] in the pipeline.
  /// Always `false` when either status is terminal.
  bool hasReached(ApplicationStatus other) {
    final rank = pipelineRank;
    final otherRank = other.pipelineRank;
    if (rank == null || otherRank == null) return false;
    return rank >= otherRank;
  }
}
