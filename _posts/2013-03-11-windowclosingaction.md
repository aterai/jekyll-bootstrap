---
layout: post
category: swing
folder: WindowClosingAction
title: JPopupMenuなどからWindowを閉じる
tags: [JFrame, JPopupMenu, JToolBar, JMenuBar]
author: aterai
pubdate: 2013-03-11T17:04:49+09:00
description: JPopupMenuや、JToolBarなどに親Windowを閉じるためのActionを作成します。
image: https://lh6.googleusercontent.com/-xWsEbhvjfDY/UT2P-83x0FI/AAAAAAAABmc/7isd5KoGMQc/s800/WindowClosingAction.png
comments: true
---
## 概要
`JPopupMenu`や、`JToolBar`などに親`Window`を閉じるための`Action`を作成します。

{% download https://lh6.googleusercontent.com/-xWsEbhvjfDY/UT2P-83x0FI/AAAAAAAABmc/7isd5KoGMQc/s800/WindowClosingAction.png %}

## サンプルコード
<pre class="prettyprint"><code>private static class ExitAction extends AbstractAction {
  public ExitAction() {
    super("Exit");
  }

  @Override public void actionPerformed(ActionEvent e) {
    JComponent c = (JComponent) e.getSource();
    Window window = null;
    Container parent = c.getParent();
    if (parent instanceof JPopupMenu) {
      JPopupMenu popup = (JPopupMenu) parent;
      JComponent invoker = (JComponent) popup.getInvoker();
      window = SwingUtilities.getWindowAncestor(invoker);
    } else if (parent instanceof JToolBar) {
      JToolBar toolbar = (JToolBar) parent;
      if (((BasicToolBarUI) toolbar.getUI()).isFloating()) {
        window = SwingUtilities.getWindowAncestor(toolbar).getOwner();
      } else {
        window = SwingUtilities.getWindowAncestor(toolbar);
      }
    } else {
      Component invoker = c.getParent();
      window = SwingUtilities.getWindowAncestor(invoker);
    }
    if (window != null) {
      // window.dispose();
      window.dispatchEvent(new WindowEvent(window, WindowEvent.WINDOW_CLOSING));
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、親となる`JFrame`を取得して`window.dispatchEvent(new WindowEvent(window, WindowEvent.WINDOW_CLOSING));`を使用し、これを閉じるためのイベントを実行しています。

コンポーネントの親`Window`を取得する場合、`SwingUtilities.getWindowAncestor(...)`などが使用可能ですが、`HeavyWeightWindow`な`JPopupMenu`や`Floating`中の`JToolBar`では親`Window`とは異なる`Window`が使用されるので注意が必要です。

- `JPopupMenu`
    - `JPopupMenu#getInvoker()`を使って、`JComponent#setComponentPopupMenu(popup)`で設定したコンポーネントを取得し、`SwingUtilities.getWindowAncestor(...)`で、親`Window`を取得
- `JMenuBar`
    - `SwingUtilities.getWindowAncestor(...)`で、自身の親`Window`を取得
- `JToolBar`
    - 移動中の場合、`JComponent#setComponentPopupMenu(toolbar)`で取得した移動中の`Window`の親`Window`を`Window#getOwner()`で取得
    - 移動中では無い場合、`SwingUtilities.getWindowAncestor(toolbar)`で、自身の親`Window`を取得

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFrameの終了をキャンセル](https://ateraimemo.com/Swing/WindowClosing.html)
- [WindowAncestor(親ウィンドウ)の取得](https://ateraimemo.com/Swing/WindowAncestor.html)

<!-- dummy comment line for breaking list -->

## コメント
