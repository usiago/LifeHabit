import UIKit

// 체크박스로 progress Bar 업데이트를 위한 통신 델리게이트
protocol HabitTableViewCellDelegate: AnyObject {
    func checkboxToggled(for habit: HabitDataStructure)
}

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var isCompletedCheckbox: UIButton!
    
    @IBOutlet weak var identityLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var doWhereLabel: UILabel!
    
    @IBOutlet weak var rewardLabel: UILabel!
    
    weak var delegate: HabitTableViewCellDelegate?
    
    var habit: HabitDataStructure?
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    
    /* ⬇️ 세팅 */
    func setUI() {
        self.backgroundColor = .black
        
    }
    
    /* ⬇️ 기능 */

    // 체크버튼 클릭
    @IBAction func isCompletedCheckboxTapped(_ sender: Any) {
        guard var habit = habit else { return }
        
        // 상태 토글
        habit.isCompleted.toggle()
        
        // UI 업데이트
        updateUI(for: habit)
        
        // 델리게이트를 통해 상태 변경 전달
        delegate?.checkboxToggled(for: habit)
    }
    
    // UI업데이트
    func updateUI(for habit: HabitDataStructure) {
        isCompletedCheckbox.isSelected = habit.isCompleted
        isCompletedCheckbox.setImage(UIImage(systemName: habit.isCompleted ? "checkmark.square.fill" : "checkmark.square"), for: .normal)
        isCompletedCheckbox.tintColor = habit.isCompleted ? #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1) : .white
        nameLabel.textColor = habit.isCompleted ? #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1) : .white
        rewardLabel.textColor = habit.isCompleted ? #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1) : .white
    }
}




