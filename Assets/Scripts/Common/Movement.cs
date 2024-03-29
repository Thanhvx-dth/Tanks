﻿using System;
using UnityEngine;

namespace BattleCity
{
	public class Movement : MonoBehaviour
	{
		public float SpeedMove = 2f;

		[Header("Animations")]
		[SerializeField]
		protected AnimationClip AnimTop;
		[SerializeField]
		protected AnimationClip AnimRight;
		[SerializeField]
		protected AnimationClip AnimBottom;
		[SerializeField]
		protected AnimationClip AnimLeft;

		[Header("Animation level")]
		[SerializeField]
		protected AnimationMove[] AnimLevel;

		public  Direction CurrentDirection { get;  set; }

		protected Animator Animator;
		protected Collider2D Collider;
		private Direction _prevDirection;

		protected virtual void Awake()
		{
			Animator = GetComponent<Animator>();
			Collider = GetComponent<Collider2D>();
		}

		protected virtual void OnEnable()
		{
			switch (CurrentDirection)
			{
				case Direction.Top:
					AnimTop.SampleAnimation(gameObject, 0);
					break;
				case Direction.Right:
					AnimRight.SampleAnimation(gameObject, 0);
					break;
				case Direction.Bottom:
					AnimBottom.SampleAnimation(gameObject, 0);
					break;
				case Direction.Left:
					AnimLeft.SampleAnimation(gameObject, 0);
					break;
			}
			Animator.enabled = false;
		}

		protected virtual void FixedUpdate()
		{
			var beside = Collider.CheckColliderBeside(CurrentDirection);
			var move = Vector2.zero;

			switch (CurrentDirection)
			{
				case Direction.Top:
					Animator.Play(AnimTop.name);
					if (!beside)
						move.y = SpeedMove;
					break;
				case Direction.Right:
					Animator.Play(AnimRight.name);
					if (!beside)
						move.x = SpeedMove;
					break;
				case Direction.Bottom:
					Animator.Play(AnimBottom.name);
					if (!beside)
						move.y = -SpeedMove;
					break;
				case Direction.Left:
					Animator.Play(AnimLeft.name);
					if (!beside)
						move.x = -SpeedMove;
					break;
			}

			RoundPosition(CurrentDirection);
			transform.Translate(move * Time.deltaTime);
		}

		protected void SetAnimationsLevel(int value)
		{
			if (value < 0)
				return;
			if (AnimLevel.Length == 0)
				return;

			var index = value % AnimLevel.Length;
			AnimTop = AnimLevel[index].AnimTop;
			AnimRight = AnimLevel[index].AnimRight;
			AnimBottom = AnimLevel[index].AnimBottom;
			AnimLeft = AnimLevel[index].AnimLeft;
		}

		private void RoundPosition(Direction direction)
		{
			if (_prevDirection == direction)
				return;
			if (direction == Direction.Top && _prevDirection == Direction.Bottom ||
				direction == Direction.Bottom && _prevDirection == Direction.Top)
				return;
			if (direction == Direction.Right && _prevDirection == Direction.Left ||
				direction == Direction.Left && _prevDirection == Direction.Right)
				return;

			var pos = transform.position;

			if (direction == Direction.Top || direction == Direction.Bottom)
				pos.x = Mathf.Round(pos.x / Consts.SHARE) * Consts.SHARE;
			else if (direction == Direction.Right || direction == Direction.Left)
				pos.y = Mathf.Round(pos.y / Consts.SHARE) * Consts.SHARE;

			transform.position = pos;
			_prevDirection = direction;
		}

		[Serializable]
		public class AnimationMove
		{
			public AnimationClip AnimTop;
			public AnimationClip AnimRight;
			public AnimationClip AnimBottom;
			public AnimationClip AnimLeft;
		}
	}
}