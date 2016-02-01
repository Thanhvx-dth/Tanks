using UnityEngine;


namespace BattleCity.Player
{
	public class MovementPlayer : Movement
	{
		[Space(5)]
		[SerializeField]
		private float SpeedSlipOnIce = 2f;

		[Header("Sounds")]
		[SerializeField]
		private AudioClip AudioIdle;
		[SerializeField]
		private AudioClip AudioMove;
		[SerializeField]
		private AudioClip AudioStopOnIce;

		public bool LockMove { get; set; }

		private PlayerController _playerController;
		private Axis? _calcFirstAxis;
		private bool _holdHorizontal;
		private bool _holdVertical;
		private string _buttonNameHorizontal;
		private string _buttonNameVertical;
		private Vector2 _startSlipIce;
		private Vector2 _finishSlipIce;
		private float _timeSlipIce;

        protected override void Awake()
		{
			base.Awake();
            _playerController = GetComponent<PlayerController>();
			_playerController.UpgradeEvent += SetAnimationsLevel;

			_buttonNameHorizontal = _playerController.TypeItem + "_Horizontal";
			_buttonNameVertical = _playerController.TypeItem + "_Vertical";
		}

		protected override void OnEnable()
		{
			LockMove = false;
			CurrentDirection = Direction.Top;
			base.OnEnable();
		}
       
        protected override void FixedUpdate()
		{
			if (_playerController.EditorMode)
				return;
			if (LockMove)
				return;

            var upHorizontal = Top.enable;
            var downHorizontal = Bot.enable;
            var leftVertical = Left.enable;
            var rightVertical = Right.enable;

            var player = _playerController.TypeItem;
			AudioManager.PlayerAudioType audioType;
            Animator.enabled = (upHorizontal || downHorizontal || leftVertical || rightVertical);
            if (!Animator.enabled)
			{
				audioType = AudioManager.PlayerAudioType.Idle;
				AudioManager.PlaySoundPlayer(AudioIdle, true, player, audioType);

				SlipIce();

				_calcFirstAxis = null;
				_holdHorizontal = false;
				_holdVertical = false;
				return;
			}

			audioType  = AudioManager.PlayerAudioType.Move;
			AudioManager.PlaySoundPlayer(AudioMove, true, player, audioType);

           
            if (upHorizontal) {
                CurrentDirection = Direction.Top;
            }
            else if (downHorizontal)
            {
                CurrentDirection = Direction.Bottom;
            }
            else if (leftVertical)
            {
                CurrentDirection = Direction.Left;
            }
            else if (rightVertical)
            {
                CurrentDirection = Direction.Right;
            }
            _holdHorizontal = (upHorizontal || downHorizontal);
            _holdVertical = (leftVertical || rightVertical);
           
            base.FixedUpdate();
		}

		public void SlipIce()
		{
			var pos = transform.position;
			var x = Mathf.RoundToInt(pos.x);
			var y = Mathf.RoundToInt(pos.y);
			var block = FieldController.Instance.GetCell(x, y);
			if (block == null || block.TypeItem != Block.Ice)
				return;

			var beside = Collider.CheckColliderBeside(CurrentDirection);
			if (beside)
				return;

			if (_holdHorizontal || _holdVertical)
			{
				AudioManager.PlaySecondarySound(AudioStopOnIce);

				_timeSlipIce = Time.time;
				_startSlipIce = transform.position;

				_finishSlipIce = _startSlipIce;
				switch (CurrentDirection)
				{
					case Direction.Top:
						_finishSlipIce.y += 1;
						break;
					case Direction.Right:
						_finishSlipIce.x += 1;
						break;
					case Direction.Bottom:
						_finishSlipIce.y -= 1;
						break;
					case Direction.Left:
						_finishSlipIce.x -= 1;
						break;
				}
                /*upHorizontal = false;
                downHorizontal = false;
                leftVertical = false;
                rightVertical = false;*/
            }

			var time = (Time.time - _timeSlipIce) * SpeedSlipOnIce;
			transform.position = Vector2.Lerp(_startSlipIce, _finishSlipIce, time);
           
        }

        private enum Axis
		{
			Horizontal,
			Vertical
		}
       
    }
   
}