---
layout: post
category: swing
folder: CloseInternalFrame
title: JInternalFrameを閉じる
tags: [JInternalFrame, JDesktopPane, DesktopManager]
author: aterai
pubdate: 2008-05-05T20:51:51+09:00
description: 選択中のJInternalFrameをDesktopManagerなどを使用して外部から閉じる(JDesktopPaneから除去する)方法をテストします。
comments: true
---
## 概要
選択中の`JInternalFrame`を`DesktopManager`などを使用して外部から閉じる(`JDesktopPane`から除去する)方法をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJcTXtdNI/AAAAAAAAAUY/zL_wkJJa_Ks/s800/CloseInternalFrame.png %}

## サンプルコード
<pre class="prettyprint"><code>closeSelectedFrameAction1 = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    JInternalFrame f = desktop.getSelectedFrame();
    if(f!=null) {
      desktop.getDesktopManager().closeFrame(f);
    }
  }
};
</code></pre>

<pre class="prettyprint"><code>closeSelectedFrameAction2 = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    JInternalFrame f = desktop.getSelectedFrame();
    if(f!=null) {
      f.doDefaultCloseAction();
    }
  }
};
</code></pre>

<pre class="prettyprint"><code>closeSelectedFrameAction3 = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    try{
      JInternalFrame f = desktop.getSelectedFrame();
      if(f!=null) {
        f.setClosed(true);
      }
    }catch(java.beans.PropertyVetoException ex) {
      ex.printStackTrace();
    }
  }
};
</code></pre>

<pre class="prettyprint"><code>disposeSelectedFrameAction = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    JInternalFrame f = desktop.getSelectedFrame();
    if(f!=null) {
      f.dispose();
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、選択されている`JInternalFrame`をツールバーのボタンや<kbd>Esc</kbd>キー(`OS`が`Windows`の場合のデフォルトは、<kbd>Ctrl+F4</kbd>)で閉じることができます。

- `RED`
    - `JInternalFrame#dispose`メソッドを使用
    - 閉じた後、他のフレームに選択状態が移動しない
- `GREEN`
    - `DesktopManager#closeFrame`メソッドを使用
- `BLUE`
    - `JInternalFrame#doDefaultCloseAction`メソッドを使用
- `YELLOW`
    - `JInternalFrame#setClosed(true)`メソッドを使用

<!-- dummy comment line for breaking list -->

- - - -
`JDK 1.5` + `WindowsLookAndFeel`では、`JInternalFrame`を閉じたとき、アイコン化されている`JInternalFrame`には選択状態は移動しません。

- - - -
- メモ
    - [<Swing Dev> 8 Review request for 8012004: JINTERNALFRAME NOT BEING FINALIZED AFTER CLOSING](http://mail.openjdk.java.net/pipermail/swing-dev/2013-April/002688.html)
    - [Bug ID: 4759312 JInternalFrame Not Being Finalized After Closing](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4759312)

<!-- dummy comment line for breaking list -->

## コメント
