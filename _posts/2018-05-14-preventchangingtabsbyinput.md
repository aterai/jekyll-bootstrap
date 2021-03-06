---
layout: post
category: swing
folder: PreventChangingTabsByInput
title: JTabbedPaneでマウスやキー入力によるタブ切替を無効にする
tags: [JTabbedPane, JLayer]
author: aterai
pubdate: 2018-05-14T16:52:16+09:00
description: JTabbedPaneでマウスクリックやキー入力といったユーザ操作イベントによるタブ切替を無効にします。
image: https://drive.google.com/uc?id=16r3rq9ec_trXinEuHffylP6ycwwlGFUGaw
comments: true
---
## 概要
`JTabbedPane`でマウスクリックやキー入力といったユーザ操作イベントによるタブ切替を無効にします。

{% download https://drive.google.com/uc?id=16r3rq9ec_trXinEuHffylP6ycwwlGFUGaw %}

## サンプルコード
<pre class="prettyprint"><code>class DisableInputLayerUI extends LayerUI&lt;Component&gt; {
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(
        AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK
        | AWTEvent.MOUSE_WHEEL_EVENT_MASK | AWTEvent.KEY_EVENT_MASK
        | AWTEvent.FOCUS_EVENT_MASK | AWTEvent.COMPONENT_EVENT_MASK);
    }
  }

  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }

  @Override public void eventDispatched(AWTEvent e, JLayer&lt;? extends Component&gt; l) {
    if (e instanceof InputEvent &amp;&amp; Objects.equals(l.getView(), e.getSource())) {
      ((InputEvent) e).consume();
    }
  }
}
</code></pre>

## 解説
- 上: `setEnabled(false)`
    - `JTabbedPane#setEnabled(false)`ですべてのタブの切替を禁止
        - 内部タブコンポーネントには影響しない
        - `next`ボタンで`JTabbedPane#setSelectedIndex(...)`メソッドを使用してタブを切り替えることは可能
    - `JTabbedPane#setFocusable(false)`を設定している場合でも、`WindowsLookAndFeel`ではマウスカーソルのあるタブがハイライトされる
        - `UIManager.put("TabbedPane.disabledAreNavigable", Boolean.TRUE)`は効果がない
        - [DisabledなJMenuItemのハイライトをテスト](https://ateraimemo.com/Swing/DisabledAreNavigable.html)
- 中: `setTabComponentAt(...)`
    - 上のサンプルと同様に`JTabbedPane#setEnabled(false)`ですべてのタブの切替を禁止
    - `JTabbedPane#setTabComponentAt(idx, new JLabel(title))`でタブタイトルコンポーネントを`JLabel`に置き換え、使用不可になっているタブタイトルの文字色を使用可の状態に戻す
- 下: `DisableInputLayerUI()`
    - `JTabbedPane`にマウスイベントやキー入力イベントをすべて消費する`LayerUI`を設定してすべてのタブの切替を禁止
    - `LayerUI#eventDispatched(...)`メソッドをオーバーライドしてすべての`InputEvent`を消費すると内部タブコンポーネント(このサンプルでは`JTextField`)も入力不可になるので、`JLayer`を設定した`JTabbedPane`の場合のみイベントを消費する用設定
        
        <pre class="prettyprint"><code>@Override
        public void eventDispatched(AWTEvent e, JLayer&lt;? extends Component&gt; l) {
          if (e instanceof InputEvent &amp;&amp; Objects.equals(l.getView(), e.getSource())) {
            ((InputEvent) e).consume();
          }
        }
</code></pre>
    - * 参考リンク [#reference]
- [JTabbedPane#setEnabledAt(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTabbedPane.html#setEnabledAt-int-boolean-)
- [LayerUI#eventDispatched(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/LayerUI.html#eventDispatched-java.awt.AWTEvent-javax.swing.JLayer-)

<!-- dummy comment line for breaking list -->

## コメント
