---
layout: post
title: JInternalFrameをJFrameとして表示する
category: swing
folder: InternalFrameTitleBar
tags: [JFrame, JInternalFrame, MouseListener, MouseMotionListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-08-31

## JInternalFrameをJFrameとして表示する
`JFrame`のタイトルバーなどを非表示にし、`JInternalFrame`のタイトルバーでこれらを代用します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTOo9LcVwI/AAAAAAAAAcs/fUEpKhXr_aI/s800/InternalFrameTitleBar.png)

### サンプルコード
<pre class="prettyprint"><code>final JInternalFrame internal = new JInternalFrame("@title@");
BasicInternalFrameUI ui = (BasicInternalFrameUI)internal.getUI();
Component title = ui.getNorthPane();
for(MouseMotionListener l:title.getListeners(MouseMotionListener.class)) {
  title.removeMouseMotionListener(l);
}
DragWindowListener dwl = new DragWindowListener();
title.addMouseListener(dwl);
title.addMouseMotionListener(dwl);
JPanel p = new JPanel(new BorderLayout());
p.add(new JScrollPane(new JTree()));
p.add(new JButton(new AbstractAction("close") {
  @Override public void actionPerformed(ActionEvent e) {
    Window w = SwingUtilities.windowForComponent((Component)e.getSource());
    //w.dispose();
    w.getToolkit().getSystemEventQueue().postEvent(
      new WindowEvent(w, WindowEvent.WINDOW_CLOSING));
  }
}), BorderLayout.SOUTH);
internal.getContentPane().add(p);
internal.setVisible(true);

KeyboardFocusManager focusManager = KeyboardFocusManager.getCurrentKeyboardFocusManager();
focusManager.addPropertyChangeListener(new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    String prop = e.getPropertyName();
    if("activeWindow".equals(prop)) {
      try{
        internal.setSelected(e.getNewValue()!=null);
      }catch(PropertyVetoException ex) {
        ex.printStackTrace();
      }
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JInternalFrame`のタイトルバーを使用することで、タイトルバーに閉じるボタンのないフレームを作成しています。

- `JFrame#setUndecorated(true)`で、`JFrame`のタイトルバーなどを非表示
- `BasicInternalFrameUI#getNorthPane()`で`JInternalFrame`のタイトルバーを取得
    - 元の`MouseMotionListener`を削除
    - `JInternalFrame`をドラッグすると親の`JFrame`が移動する`MouseMotionListener`を追加

<!-- dummy comment line for breaking list -->

- 制限
    - 最大化、最小化、リサイズなどには未対応
        - <kbd>Alt+Space</kbd>で最大化、最小化できるが、元のサイズに戻せなくなる場合がある
    - 角の透明化には未対応
        - 目立たなくするために、`LookAndFeel`は`Nimbus`に変更
        - `JDK 1.7.0`なら、`frame.setBackground(new Color(0,0,0,0)); frame.add(p=new MainPanel()); p.setOpaque(false);`で角の透明化が可能

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JWindowをマウスで移動](http://terai.xrea.jp/Swing/DragWindow.html)
- [JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする](http://terai.xrea.jp/Swing/CustomDecoratedFrame.html)
- [JRootPaneにリサイズのための装飾を設定する](http://terai.xrea.jp/Swing/WindowDecorationStyle.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JFrame`のアクティブ状態が変わったら、`JInternalFrame`の選択状態も変化するように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-11-13 (金) 14:57:18
- リサイズ可能？にする場合のテスト。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-06-10 (木) 15:07:18
    - [JRootPaneにリサイズのための装飾を設定する](http://terai.xrea.jp/Swing/WindowDecorationStyle.html)に移動。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-17 (月) 02:29:47

<!-- dummy comment line for breaking list -->

