---
layout: post
category: swing
folder: ActionEventModifiers
title: JButtonがクリックされたときにShiftキーなどが押下されているかをテストする
tags: [JButton, ActionListener, ActionEvent, InputEvent]
author: aterai
pubdate: 2018-01-01T18:58:15+09:00
description: JButtonやJMenuItemがクリックされたとき、同時にShiftキーなどが押下されているかをテストします。
image: https://drive.google.com/uc?id=1OqGPANokzyj1ocWyhI1StYYYEm0o0fCAKw
comments: true
---
## 概要
`JButton`や`JMenuItem`がクリックされたとき、同時に<kbd>Shift</kbd>キーなどが押下されているかをテストします。

{% download https://drive.google.com/uc?id=1OqGPANokzyj1ocWyhI1StYYYEm0o0fCAKw %}

## サンプルコード
<pre class="prettyprint"><code>JButton button = new JButton("TEST: ActionEvent#getModifiers()");
button.addActionListener(e -&gt; {
  // BAD EXAMPLE: boolean isShiftDown = (e.getModifiers() &amp; InputEvent.SHIFT_MASK) != 0;
  // Always use ActionEvent.*_MASK instead of InputEvent.*_MASK in ActionListener
  boolean isShiftDown = (e.getModifiers() &amp; ActionEvent.SHIFT_MASK) != 0;
  if (isShiftDown) {
    LOGGER.info("JButton: Shift is Down");
  } else {
    LOGGER.info("JButton: Shift is Up");
  }
  if ((e.getModifiers() &amp; AWTEvent.MOUSE_EVENT_MASK) != 0) {
    LOGGER.info("JButton: Mouse event mask");
  }
});
</code></pre>

## 解説
- `JButton` + `ActionListener`
    - `(e.getModifiers() & ActionEvent.SHIFT_MASK) != 0`で<kbd>Shift</kbd>キーが押されているかを判断する
    - `ActionListener`内で`(e.getModifiers() & InputEvent.SHIFT_MASK) != 0`と`InputEvent.SHIFT_MASK`を使用すべきではない
    - どちらも定数値は`1`だが、`InputEvent.SHIFT_MASK`はキーストローク用、また`Java 9`から`InputEvent.SHIFT_MASK`は非推奨で`InputEvent.SHIFT_DOWN_MASK`を使うべき
    - `InputEvent.SHIFT_DOWN_MASK`は`InputEvent.getModifiersEx()`と合わせて使用する
    - `MouseEvent`や`KeyEvent`は`InputEvent`を継承しているが、`ActionEvent`は継承していないので`getModifiersEx()`メソッドは存在しない
        - [ActionEvent.SHIFT_MASK](https://docs.oracle.com/javase/jp/9/docs/api/constant-values.html#java.awt.event.ActionEvent.SHIFT_MASK): `1`
        - [InputEvent.SHIFT_MASK](https://docs.oracle.com/javase/jp/9/docs/api/constant-values.html#java.awt.event.InputEvent.SHIFT_MASK): `1` `@Deprecated(since="9")`
        - [InputEvent.SHIFT_DOWN_MASK](https://docs.oracle.com/javase/jp/9/docs/api/constant-values.html#java.awt.event.InputEvent.SHIFT_DOWN_MASK): `64`
- `JTextField` + `InputMap`、または`KeyListener`、`MouseListener`
    - `(e.getModifiersEx() & InputEvent.SHIFT_DOWN_MASK) != 0`で<kbd>Shift</kbd>キーが押されているかを判断する
    - `MouseEvent`は`InputEvent`を継承しているので、`MouseListener`内では`InputEvent#isShiftDown()`なども使用可能

<!-- dummy comment line for breaking list -->

- - - -
- `JMenuItem`などがキー入力ではなくマウスでクリックされたかどうかの判断は、`(ActionEvent#getModifiers() & AWTEvent.MOUSE_EVENT_MASK) != 0`で判断する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [ActionEvent (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/event/ActionEvent.html)
- [java - isShiftDown when JButton pressed? - Stack Overflow](https://stackoverflow.com/questions/5592065/isshiftdown-when-jbutton-pressed)

<!-- dummy comment line for breaking list -->

## コメント
