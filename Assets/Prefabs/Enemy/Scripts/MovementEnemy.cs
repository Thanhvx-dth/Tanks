using UnityEngine;

namespace BattleCity.Enemy
{
	public class MovementEnemy : Movement
	{
		[Header("Animations bonus")]
		[SerializeField]
		private AnimationClip AnimBonusTop;
		[SerializeField]
		private AnimationClip AnimBonusRight;
		[SerializeField]
		private AnimationClip AnimBonusBottom;
		[SerializeField]
		private AnimationClip AnimBonusLeft;

		private EnemyController _enemyController;

		public void SetDirection(Direction value)
		{
			CurrentDirection = value;
		}

		protected override void Awake()
		{
			base.Awake();
			_enemyController = GetComponent<EnemyController>();
			_enemyController.ChangedArmorEvent += SetAnimationsLevel;
		}

		protected override void OnEnable()
		{
			
			base.OnEnable();
		}

		protected override void FixedUpdate()
		{
			var isFreezed = _enemyController.IsFreezed;

			Animator.enabled = !isFreezed;

			if (isFreezed)
				return;

			base.FixedUpdate();		
		}
	}
}