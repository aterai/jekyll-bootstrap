---
layout: post
category: swing
folder: ContinuouslySelectWords
title: JTextAreaのCaretを変更してマウスのダブルクリックによる単語選択の動作を変更する
tags: [JTextArea, Caret, JTextComponent, MouseMotionListener]
author: aterai
pubdate: 2019-11-18T02:00:49+09:00
description: JTextAreaのCaretを変更してマウスのダブルクリックで単語を選択したあとの継続ドラッグで次の単語まで選択範囲を拡張するよう変更します。
image: https://drive.google.com/uc?id=1O1N1ZcEKZi7XbOU5jOojctlGn3hY5MJ7
comments: true
---
## 概要
`JTextArea`の`Caret`を変更してマウスのダブルクリックで単語を選択したあとの継続ドラッグで次の単語まで選択範囲を拡張するよう変更します。

{% download https://drive.google.com/uc?id=1O1N1ZcEKZi7XbOU5jOojctlGn3hY5MJ7 %}

## サンプルコード
<pre class="prettyprint"><code>class SelectWordCaret extends DefaultCaret {
  private SelectingMode selectingMode = SelectingMode.CHAR;
  private int p0; // = Math.min(getDot(), getMark());
  private int p1; // = Math.max(getDot(), getMark());

  @Override public void mousePressed(MouseEvent e) {
    super.mousePressed(e);
    int clickCount = e.getClickCount();
    if (SwingUtilities.isLeftMouseButton(e) &amp;&amp; !e.isConsumed()) {
      if (clickCount == 2) {
        selectingMode = SelectingMode.WORD;
        p0 = Math.min(getDot(), getMark());
        p1 = Math.max(getDot(), getMark());
      } else if (clickCount &gt;= 3) {
        selectingMode = SelectingMode.ROW;
        JTextComponent target = getComponent();
        int offs = target.getCaretPosition();
        try {
          p0 = Utilities.getRowStart(target, offs);
          p1 = Utilities.getRowEnd(target, offs);
          setDot(p0);
          moveDot(p1);
        } catch (BadLocationException ex) {
          UIManager.getLookAndFeel().provideErrorFeedback(target);
        }
      }
    } else {
      selectingMode = SelectingMode.CHAR;
    }
  }

  @Override public void mouseDragged(MouseEvent e) {
    if (!e.isConsumed() &amp;&amp; SwingUtilities.isLeftMouseButton(e)) {
      if (selectingMode == SelectingMode.WORD) {
        continuouslySelectWords(e);
      } else if (selectingMode == SelectingMode.ROW) {
        continuouslySelectRows(e);
      }
    } else {
      super.mouseDragged(e);
    }
  }

  private void continuouslySelectWords(MouseEvent e) {
    Position.Bias[] biasRet = new Position.Bias[1];
    JTextComponent c = getComponent();
    int pos = getCaretPositionByLocation(c, e.getPoint(), biasRet);
    try {
      if (p0 &lt; pos &amp;&amp; pos &lt; p1) {
        setDot(p0);
        moveDot(p1, biasRet[0]);
      } else if (p1 &lt; pos) {
        setDot(p0);
        moveDot(Utilities.getWordEnd(c, pos), biasRet[0]);
      } else if (p0 &gt; pos) {
        setDot(p1);
        moveDot(Utilities.getWordStart(c, pos), biasRet[0]);
      }
    } catch (BadLocationException ex) {
      UIManager.getLookAndFeel().provideErrorFeedback(c);
    }
  }
  // ...
}
</code></pre>

## 解説
- `default`
    - ダブルクリックで単語選択可能
    - ダブルプレスでも単語選択可能だが、継続してマウスを左側にドラッグすると単語選択が解除されて通常の文字選択モードになり単語先頭からドラッグ位置までが選択状態になる
    - トリプルクリックで行全体を選択可能
    - トリプルプレスでは行はまだ選択状態にはならない
- `setCaret`
    - 以下のようなマウスによる選択動作を実行するため`DefaultCaret#mousePressed(...)`、`DefaultCaret#mouseDragged(...)`メソッドをオーバーライドした`Caret`を作成して、`JTextComponent#setCaret(...)`で設定
    - ダブルプレスで単語選択後、継続してマウスをドラッグした場合:
        - 選択範囲内のドラッグでは単語選択状態は変化しない
        - 選択範囲外へのドラッグは現在の単語選択状態は維持したまま、前後の単語まで選択状態を拡張する
    - トリプルプレスで行全体を選択後、継続してマウスをドラッグした場合:
        - 選択範囲内のドラッグでは行選択状態は変化しない
        - 選択範囲外へのドラッグは現在の行選択状態は維持したまま、前後の行まで選択状態を拡張する

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private void continuouslySelectRows(MouseEvent e) {
  Position.Bias[] biasRet = new Position.Bias[1];
  JTextComponent c = getComponent();
  int pos = getCaretPositionByLocation(c, e.getPoint(), biasRet);
  try {
    if (p0 &lt; pos &amp;&amp; pos &lt; p1) {
      setDot(p0);
      moveDot(p1, biasRet[0]);
    } else if (p1 &lt; pos) {
      setDot(p0);
      moveDot(Utilities.getRowEnd(c, pos), biasRet[0]);
    } else if (p0 &gt; pos) {
      setDot(p1);
      moveDot(Utilities.getRowStart(c, pos), biasRet[0]);
    }
  } catch (BadLocationException ex) {
    UIManager.getLookAndFeel().provideErrorFeedback(c);
  }
}
</code></pre>

## 参考リンク
- [JTextAreaで単語選択を実行した場合の区切り文字を変更する](https://ateraimemo.com/Swing/SelectWordAction.html)
- [Utilities#getWordStart(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Utilities.html#getWordStart-javax.swing.text.JTextComponent-int-)
- [Utilities#getWordEnd(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Utilities.html#getWordEnd-javax.swing.text.JTextComponent-int-)
- [Utilities#getRowStart(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Utilities.html#getRowStart-javax.swing.text.JTextComponent-int-)
- [Utilities#getRowEnd(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Utilities.html#getRowEnd-javax.swing.text.JTextComponent-int-)
- [java - JTextArea - selection behavior on double / triple click + moving mouse - Stack Overflow](https://stackoverflow.com/questions/58690711/jtextarea-selection-behavior-on-double-triple-click-moving-mouse)

<!-- dummy comment line for breaking list -->

## コメント
